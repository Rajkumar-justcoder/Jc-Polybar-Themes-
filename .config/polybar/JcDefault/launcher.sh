#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

## Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

## Launch

## Left bar
polybar left -c ~/.config/polybar/config.ini &

## Right bar
polybar right -c ~/.config/polybar/config.ini &

## Center bar
polybar workspace -c ~/.config/polybar/config.ini &
