#!/bin/bash

# Ansi color code variables
red="\e[0;91m"
blue="\e[0;94m"
expand_bg="\e[K"
blue_bg="\e[0;104m${expand_bg}"
red_bg="\e[0;101m${expand_bg}"
green_bg="\e[0;102m${expand_bg}"
green="\e[0;92m"
white="\e[0;97m"
bold="\e[1m"
uline="\e[4m"
reset="\e[0m"

while true; do
    read -p "Enter the length of password: " len
    if ! [[ "$len" =~ ^[0-9]+$ ]]; then
        echo -e "${red}Invalid, please enter numbers only${reset}"
        continue
    fi
    break
done

password=$(tr -dc 'A-Za-z0-9_!@#$%^&*><{}()[]+-' < /dev/urandom | head -c "$len")
echo -e "${green}Generated Password:${reset} $password"
read -p "Enter user name : " use
echo "$(date +'%Y-%m-%d %H:%M:%S') : $use  : $password" >> "$HOME/passwords.txt"
