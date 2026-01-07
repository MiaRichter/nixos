#!/usr/bin/env bash
# Скрипт активации приложения при клике на уведомление

set -e

APP_NAME="$1"
ACTION="$2"  # Обычно пустой, но может содержать действия

# Логирование (опционально)
LOG_FILE="${HOME}/.cache/mako_click.log"
echo "$(date): APP='$APP_NAME', ACTION='$ACTION'" >> "$LOG_FILE"

# Функция для поиска и активации окна
activate_window() {
    local app_name="$1"
    
    case "$XDG_SESSION_TYPE" in
        wayland)
            # Для Wayland/Hyprland
            if command -v hyprctl &> /dev/null; then
                # Ищем окно по классу или названию
                hyprctl dispatch focuswindow "$app_name" 2>/dev/null || \
                hyprctl dispatch focuswindow "class:$app_name" 2>/dev/null || \
                hyprctl dispatch focuswindow "title:.*$app_name.*" 2>/dev/null
            elif command -v swaymsg &> /dev/null; then
                swaymsg "[app_id=\"$app_name\"] focus" 2>/dev/null
            fi
            ;;
        x11)
            # Для X11
            if command -v wmctrl &> /dev/null; then
                wmctrl -a "$app_name" 2>/dev/null || \
                wmctrl -xF -a "$app_name" 2>/dev/null
            fi
            ;;
    esac
}

# Маппинг названий приложений
case "$APP_NAME" in
    # Браузеры
    "firefox"|"Firefox")
        activate_window "firefox"
        ;;
    "chromium"|"google-chrome"|"brave")
        activate_window "Chromium"
        ;;
    
    # Терминалы
    "kitty"|"alacritty"|"foot"|"wezterm")
        activate_window "kitty" || activate_window "Alacritty" || activate_window "foot"
        ;;
    
    # Мессенджеры
    "telegram"|"TelegramDesktop")
        activate_window "Telegram"
        ;;
    "discord")
        activate_window "discord"
        ;;
    "signal"|"Signal")
        activate_window "Signal"
        ;;
    
    # Музыка
    "spotify"|"Spotify")
        activate_window "Spotify"
        ;;
    "ncmpcpp"|"mpd")
        # Для терминальных плееров - фокус на терминал
        if command -v hyprctl &> /dev/null; then
            hyprctl dispatch focuswindow "kitty"
        fi
        ;;
    
    # Файловые менеджеры
    "thunar"|"nautilus"|"dolphin")
        activate_window "$APP_NAME"
        ;;
    
    # Системные
    "notify-send")
        # Игнорируем тестовые уведомления
        exit 0
        ;;
    
    *)
        # Пробуем активировать по общему правилу
        activate_window "$APP_NAME"
        ;;
esac

# Закрываем уведомление после клика
if command -v makoctl &> /dev/null; then
    makoctl dismiss
fi

exit 0