#!/bin/bash

THEMES_DIR="$HOME/.config/waybar/themes"
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"
WAYBAR_CSS="$HOME/.config/waybar/style.css"
ALACRITTY_CONF="$HOME/.config/alacritty/alacritty.toml"
CURRENT="$HOME/.config/waybar/current-theme"

# Список папок которые реально существуют
chosen=$(ls -d "$THEMES_DIR"/*/  | xargs -n1 basename | rofi -dmenu -p " Тема" -i)

[ -z "$chosen" ] && exit

THEME="$THEMES_DIR/$chosen"

# Waybar CSS
cp "$THEME/waybar.css" "$WAYBAR_CSS"

# Alacritty
cp "$THEME/alacritty.toml" "$ALACRITTY_CONF"

if [ -f "$THEME/fastfetch.jsonc" ]; then
    cp "$THEME/fastfetch.jsonc" "$HOME/.config/fastfetch/config.jsonc"
fi

if [ -f "$THEME/hyprlock.conf" ]; then
    cp "$THEME/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
fi

# Hyprland — меняем только строки с цветами
if [ -f "$THEME/hyprland.conf.patch" ]; then
    ACTIVE=$(grep "col.active_border" "$THEME/hyprland.conf.patch" | sed 's/.*= //')
    INACTIVE=$(grep "col.inactive_border" "$THEME/hyprland.conf.patch" | sed 's/.*= //')
    SHADOW=$(grep "^color" "$THEME/hyprland.conf.patch" | sed 's/.*= //')

    sed -i "s|col.active_border = .*|col.active_border = $ACTIVE|g" "$HYPR_CONF"
    sed -i "s|col.inactive_border = .*|col.inactive_border = $INACTIVE|g" "$HYPR_CONF"
    sed -i "s|color = rgba(1a1a1a.*|color = $SHADOW|g" "$HYPR_CONF"

    hyprctl reload
fi

# Обновляем надпись на баре
echo "$chosen" > "$CURRENT"
WALLPAPER="$HOME/Pictures/wallpapers/$chosen.jpg"
if [ -f "$WALLPAPER" ]; then
    awww img "$WALLPAPER" --transition-type fade --transition-duration 1
fi

pkill -SIGRTMIN+8 waybar


# Перезапускаем waybar с новым css
pkill waybar
sleep 0.3
waybar &
