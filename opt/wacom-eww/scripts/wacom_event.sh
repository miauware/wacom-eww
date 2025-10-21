#!/bin/bash
USER="$1"
ACTION="$2"
if [ -z "$USER" ] || [ -z "$ACTION" ]; then
  echo "ERROR: Missing arguments: expected USER and ACTION" >&2
  exit 1
fi

# INFO: Setup environment for connecting to eww daemon
USER_HOME=$(eval echo "~$USER")
USER_UID=$(id -u "$USER")
export XDG_RUNTIME_DIR="/run/user/$USER_UID"
export DISPLAY=":0"

# INFO: Path to rice config
RICE_FILE="$USER_HOME/.config/bspwm/.rice"
if [ ! -f "$RICE_FILE" ]; then
  echo "ERROR: Rice file not found at $RICE_FILE" >&2
  exit 1
fi

RICE_NAME=$(<"$RICE_FILE")
RICE_DIR="$USER_HOME/.config/bspwm/rices/${RICE_NAME}/bar"
if [ ! -d "$RICE_DIR" ]; then
  echo "ERROR: Rice directory not found: $RICE_DIR" >&2
  exit 1
fi


EWW_BIN="$(command -v eww || echo /usr/bin/eww)"

# INFO: Update widget based on ACTION
if [ "$ACTION" = "add" ]; then
  $EWW_BIN -c "$RICE_DIR" update wacom_connected=true
elif [ "$ACTION" = "remove" ]; then
  $EWW_BIN -c "$RICE_DIR" update wacom_connected=false
else
  echo "ERROR: Unknown action: $ACTION" >&2
  exit 1
fi
