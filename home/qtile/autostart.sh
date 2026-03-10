#!/usr/bin/env bash

# Notifications
dunst &

# Network manager applet
nm-applet &

# X11-only: picom compositor (Wayland composites natively)
if [ -z "$WAYLAND_DISPLAY" ]; then
    picom &
fi
