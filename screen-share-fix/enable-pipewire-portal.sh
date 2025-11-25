#!/usr/bin/env bash
set -euo pipefail

# Ensures PipeWire (with wireplumber) and xdg-desktop-portal services are enabled and running for screen sharing.

enable() {
  systemctl --user enable --now pipewire.socket
  systemctl --user enable --now pipewire.service
  systemctl --user enable --now wireplumber.service
  systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-gnome.service
}

if systemctl --user status pipewire >/dev/null 2>&1 && systemctl --user status wireplumber >/dev/null 2>&1; then
  echo "[*] PipeWire and wireplumber are present."
else
  echo "[!] PipeWire/wireplumber not found. Install pipewire, wireplumber, xdg-desktop-portal-gnome."
fi

enable
echo "[*] Done. If browsers were running, restart them or relogin for portals to pick up."
