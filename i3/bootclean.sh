#!/usr/bin/env bash

# Clean up various systems every now and then (or when pressing the hotkey)

# Clean up Docker
DOCKER_LOG=/tmp/docklog

docker system prune -af > /tmp/docklog 2>&1

notify-send --urgency=low --expire-time=15000 "Docker cleanup complete" "$(tail -n1 $DOCKER_LOG)"

