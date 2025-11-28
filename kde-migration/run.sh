#!/usr/bin/env bash
set -euo pipefail

# Install KDE Plasma (full set) while keeping GNOME intact; backup user configs first.
# Hardware: AMD Ryzen AI 7 + Radeon 860/840M, 30 GiB RAM — Plasma/Wayland is fine.

if [ "$(id -u)" -eq 0 ]; then
  echo "Run as regular user (sudo will be used when needed)." >&2
  exit 1
fi

timestamp=$(date +%F-%H%M)
backup_dir="$HOME/kde-backup-$timestamp"
mkdir -p "$backup_dir"
echo "[*] Backing up key configs to $backup_dir ..."
for d in .config .local/share .var/app .mozilla .config/opera; do
  src="$HOME/$d"
  if [ -e "$src" ]; then
    echo "  - $src"
    rsync -aH "$src" "$backup_dir"/
  fi
done

echo "[*] Setting default display manager to sddm (preseed to avoid prompt)..."
echo "sddm shared/default-x-display-manager select sddm" | sudo debconf-set-selections

echo "[*] Updating package lists..."
sudo apt-get update

echo "[*] Installing KDE Plasma full stack..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  kubuntu-desktop kde-standard kde-spectacle \
  xdg-desktop-portal-kde \
  pipewire pipewire-audio pipewire-alsa pipewire-pulse wireplumber

echo "[*] Enabling PipeWire/WirePlumber user services..."
systemctl --user enable --now pipewire.socket pipewire.service pipewire-pulse.socket pipewire-pulse.service wireplumber.service

echo
echo "Done."
echo "- KDE/Plasma installed (choose Plasma session at login; SDDM set as default DM)."
echo "- Backups: $backup_dir"
echo "- GNOME left intact; removal script will be provided separately."
