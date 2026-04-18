#!/usr/bin/env sh

export LANG=en_US.UTF8

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
fi

xrandr --output eDP-1 --off --output DP-2-1 --mode 1920x1080 --fb 1920x1080

gentoo-pipewire-launcher &

exec /usr/bin/wmaker
