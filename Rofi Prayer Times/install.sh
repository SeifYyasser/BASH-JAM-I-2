#!/bin/bash
set -e

APP_DIR="$HOME/.local/share/prayer-times"
BIN_DIR="$HOME/.local/bin"
CONFIG="$HOME/.prayer_times_config"

echo "Installing Prayer Times…"


mkdir -p "$APP_DIR"
mkdir -p "$BIN_DIR"


cp prayer_times.sh "$APP_DIR/"
cp prayer_times_style.css "$APP_DIR/"
chmod +x "$APP_DIR/prayer_times.sh"

ln -sf "$APP_DIR/prayer_times.sh" "$BIN_DIR/prayer-times"


if [[ ! -f "$CONFIG" ]]; then
    cp config.example "$CONFIG"
    echo "Created config at $CONFIG"
else
    echo "Config already exists, leaving it untouched"
fi

echo "Done! Run with: prayer-times"
