#!/usr/bin/env sh

export LANG=en_US.UTF8

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
fi

gentoo-pipewire-launcher &

exec /usr/bin/wmaker
