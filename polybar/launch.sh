#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

echo $BASH_SOURCE
# Make sure GitHub key exists
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

if [ ! -f "$DIR/github.token" ]; then
    touch "$DIR/github.token"
fi

for MONITOR in $( xrandr --listactivemonitors | tail -n+2 | awk '{print $4}' );
do

    echo "Launching top bar on $MONITOR"
    (
        MONITOR="$MONITOR" \
        polybar topbar 2>&1 3>&1 \
        | ts '[%Y-%m-%d %H:%M:%S][top] ' \
        >> $HOME/.config/polybar/log.log \
    &)

    echo "Launching bottom bar on $MONITOR"
    (
        MONITOR="$MONITOR" \
        polybar bottombar 2>&1 3>&1 \
        | ts '[%Y-%m-%d %H:%M:%S][btn] ' \
        >> $HOME/.config/polybar/log.log \
    &)
done


echo "Bars launched..."

