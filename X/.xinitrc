#!/bin/sh

xrdb -merge ~/.Xresources &
exec dbus-run-session /usr/bin/i3
