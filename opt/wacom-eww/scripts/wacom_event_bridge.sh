#!/bin/bash
# INFO: Bridge script called by udev to safely run wacom_event.sh and notify status

ACTION="$1"

# FIXME: Must provide an action argument ("add" or "remove")
if [ -z "$ACTION" ]; then
  echo "ERROR: No action provided" >&2
  exit 1
fi

# INFO: Detect active graphical user (seat0 = current local session)
USER=$(loginctl list-sessions | awk '/seat0/ {print $3; exit}')
if [ -z "$USER" ]; then
  echo "ERROR: No active graphical user found" >&2
  exit 1
fi

USER_UID=$(id -u "$USER")
export XDG_RUNTIME_DIR="/run/user/$USER_UID"
export DISPLAY=":0"

GLOBAL_SCRIPT="/opt/wacom-eww/scripts/wacom_event.sh"
if [ ! -x "$GLOBAL_SCRIPT" ]; then
  echo "ERROR: Global script not executable: $GLOBAL_SCRIPT" >&2
  sudo -u "$USER" DISPLAY=:0 notify-send "Wacom EWW" "❌ Missing or non-executable: $GLOBAL_SCRIPT"
  exit 1
fi

ACTION_TEXT=$([ "$ACTION" = "add" ] && echo "connected" || echo "disconnected")

# HACK: Small delay to allow X to initialize before notifications
sleep 1

# INFO: Run main Wacom event handler
sudo -u "$USER" env DISPLAY=":0" XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" \
  bash "$GLOBAL_SCRIPT" "$USER" "$ACTION"

# INFO: Show success notification to user 
sudo -u "$USER" env DISPLAY=":0" XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" \
  notify-send --icon tablet "Wacom device $ACTION_TEXT successfully"
