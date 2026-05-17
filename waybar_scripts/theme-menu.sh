#!/bin/bash

THEMES_DIR="$HOME/.config/waybar/themes"

# Получаем список папок
chosen=$(ls -d "$THEMES_DIR"/*/  | xargs -n1 basename | rofi -dmenu -p "Тема" -i)

[ -z "$chosen" ] && exit

# Применяем waybar
cp "$THEMES_DIR/$chosen/waybar.css" "$HOME/.config/waybar/style.css"

# Применяем hyprland
cp "$THEMES_DIR/$chosen/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
hyprctl reload

# Применяем alacritty (применяется автоматически при изменении файла)
cp "$THEMES_DIR/$chosen/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

# Обновляем waybar
echo "$chosen" > "$HOME/.config/waybar/current-theme"
pkill -SIGRTMIN+8 waybar
pkill waybar && waybar &
