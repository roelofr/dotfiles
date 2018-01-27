#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
(
    polybar topbar 2>&1 3>&1 \
    | ts '[%Y-%m-%d %H:%M:%S][top] ' \
    >> $HOME/.config/polybar/log.log \
&)
(
    polybar bottombar 2>&1 3>&1 \
    | ts '[%Y-%m-%d %H:%M:%S][btn] ' \
    >> $HOME/.config/polybar/log.log \
&)


echo "Bars launched..."

