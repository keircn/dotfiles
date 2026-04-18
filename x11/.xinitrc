#!/usr/bin/env sh

export LANG=en_US.UTF8

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
fi

xrandr --output eDP-1 --mode 1366x768 --pos 0x250 \
       --output DP-2-1 --primary --mode 1920x1080 --pos 1366x0

gentoo-pipewire-launcher &

exec /usr/bin/wmaker
