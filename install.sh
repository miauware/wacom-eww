#!/bin/bash
# INFO: Installer script for the Wacom ↔ EWW integration (no sudoers modification required)

set -e

# INFO: Define paths
SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
OPT_TARGET="/opt/wacom-eww"
UDEV_TARGET="/etc/udev/rules.d/99-wacom-eww.rules"

install_files() {
    echo "[*] Installing Wacom ↔ EWW integration..."

    # INFO: Create target directories and copy scripts
    sudo mkdir -p "$OPT_TARGET/scripts"
    sudo cp -r "$SRC_DIR/opt/wacom-eww/scripts/"* "$OPT_TARGET/scripts/"
    sudo cp -r "$SRC_DIR/opt/wacom-eww/wacom.png"* "$OPT_TARGET/wacom.png"
    sudo chmod 644 "$OPT_TARGET/wacom.png"
    sudo chmod +x "$OPT_TARGET/scripts/"*.sh
    sudo chmod 755 -R "$OPT_TARGET"

    # INFO: Install udev rule
    sudo mkdir -p /etc/udev/rules.d
    sudo cp "$SRC_DIR/etc/udev/rules.d/99-wacom-eww.rules" "$UDEV_TARGET"
    sudo chmod 644 "$UDEV_TARGET"

    # INFO: Reload udev rules
    sudo udevadm control --reload
    sudo udevadm trigger

    echo "[✓] Installation complete."
}

remove_files() {
    echo "[*] Removing Wacom ↔ EWW integration..."

    # INFO: Remove installed files
    sudo rm -rf "$OPT_TARGET"
    sudo rm -f "$UDEV_TARGET"

    # INFO: Reload udev rules after cleanup
    sudo udevadm control --reload
    sudo udevadm trigger

    echo "[✓] Removal complete."
}

case "$1" in
    install)
        install_files
        ;;
    remove)
        remove_files
        ;;
    *)
        echo "Usage: $0 {install|remove}"
        exit 1
        ;;
esac
