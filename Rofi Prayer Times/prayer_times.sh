#!/bin/bash




######################## cache to avoid api abuse and hard coded fetch
COORD_CACHE="$HOME/.cache/prayer_coords"

get_coords() {
    if [[ -f "$COORD_CACHE" ]]; then
        read -r lat lon < <(tr '\n' ' ' < "$COORD_CACHE")
        return
    fi

    read lat lon < <(
        curl -s https://ipapi.co/json/ |
        jq -r '.latitude, .longitude'
    )

    if ! [[ $lat =~ ^-?[0-9]+(\.[0-9]+)?$ ]] || \
       ! [[ $lon =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Invalid coordinates from IP"
        exit 1
    fi

    printf "%s %s\n" "$lat" "$lon" > "$COORD_CACHE"
}

###############read my custom config and make sure it exits
CONFIG_FILE="$HOME/.prayer_times_config"
METHOD=3

if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "Configuration file not found: $CONFIG_FILE"
    exit 1
fi


#actually get coords
get_coords
[[ -z "$lat" || -z "$lon" ]] && {
    echo "Coordinates missing"
    exit 1
}

######################const coords of Mekkah#################
Mlon=39.826215
Mlat=21.422526
delta_lon=$(awk -v a="$Mlon" -v b="$lon" 'BEGIN{print a-b}')

##############################calculating approx. qibla direction
qibla_deg=$(awk -v lat="$lat" -v lon="$lon" -v Mlat="$Mlat" -v Mlon="$Mlon" '
BEGIN {
    pi = atan2(0,-1)

    lat *= pi/180
    lon *= pi/180
    Mlat *= pi/180
    Mlon *= pi/180

    dlon = Mlon - lon

    x = sin(dlon) * cos(Mlat)
    y = cos(lat)*sin(Mlat) - sin(lat)*cos(Mlat)*cos(dlon)

    deg = atan2(x,y)*180/pi
    print (deg+360)%360
}')

##################time helpers##################
clean_time() {
    echo "$1" | grep -oE '^[0-9]{1,2}:[0-9]{2}'
}

tosecond() {
    local t
    t=$(clean_time "$1") || return 1
    [[ -z "$t" ]] && return 1
    local h=${t%%:*}
    local m=${t##*:}
    echo $((h * 3600 + m * 60))
}


calculate_countdown() {
    local target="$1"
    local now_sec
    now_sec=$(tosecond "$(date +%H:%M)") || return 1
    local target_sec
    target_sec=$(tosecond "$target") || return 1
    (( target_sec <= now_sec )) && target_sec=$((target_sec + 86400))
    local diff=$((target_sec - now_sec))
    printf "(%02dh %02dm %02ds)" $((diff/3600)) $(((diff%3600)/60)) $((diff%60))
}

#############ip based
fetch_prayer_times() {
    local response
    response=$(curl -sfL \
        "https://api.aladhan.com/v1/timings?latitude=$lat&longitude=$lon&method=$METHOD"
    ) || {
        echo "Failed to fetch prayer times"
        return 1
    }

    local code
    code=$(jq -r '.code' <<< "$response")

    if [[ "$code" != "200" ]]; then
        jq -r '.data' <<< "$response" >&2
        return 1
    fi

    jq '.data.timings' <<< "$response"
}

################times' menu
build_menu() {
    local timings
    timings=$(fetch_prayer_times) || return 1
    local now_sec=$(tosecond "$(date +%H:%M)")
    menu_items=()
    menu_items+=("Qibla: ${qibla_deg}°")
    menu_items+=("------------------")
    for prayer in Fajr Dhuhr Asr Maghrib Isha; do
        time=$(jq -r ".$prayer" <<< "$timings")
        sec=$(tosecond "$time")
        if (( sec > now_sec )); then
            countdown=$(calculate_countdown "$time")
            menu_items+=("$prayer: $time $countdown")
        else
            menu_items+=("$prayer: $time")
        fi
    done
    menu_items+=("Refresh")
    menu_items+=("Exit")
    printf "%s\n" "${menu_items[@]}"
}

DIR="$(dirname "$0")"
STYLE_FILE="$DIR/prayer_times_style.css"

while true; do
    selection=$(build_menu | wofi --dmenu -p "Prayer Times" --style "$STYLE_FILE")
    case "$selection" in
        *Refresh*) continue ;;
        *Exit*) break ;;
        *) break ;;
    esac
done




#################chech dependencies of user
require() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "Missing dependency: $1"
        exit 1
    }
}

require curl
require jq
require wofi
