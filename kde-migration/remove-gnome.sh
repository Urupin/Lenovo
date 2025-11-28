#!/usr/bin/env bash
set -euo pipefail

# Remove GNOME session/DM after verifying KDE works.
# WARNING: run only after you have logged in to KDE and confirmed stability.

if [ "$(id -u)" -eq 0 ]; then
  echo "Run as regular user (sudo will be used when needed)." >&2
  exit 1
fi

read -r -p "This will purge GNOME (gdm3/gnome-shell). Continue? [y/N] " ans
case "${ans,,}" in
  y|yes) ;;
  *) echo "Aborted."; exit 0 ;;
esac

packages=(
  ubuntu-desktop
  gdm3
  gnome-shell
  gnome-session-bin
  gnome-control-center
  nautilus
  gnome-terminal
  gnome-shell-extension-appindicator
  gnome-shell-extension-desktop-icons
  gnome-backgrounds
  yaru-theme-gtk yaru-theme-icon yaru-theme-sound
)

echo "[*] Ensuring sddm is the default display manager..."
echo "sddm shared/default-x-display-manager select sddm" | sudo debconf-set-selections

echo "[*] Purging GNOME packages..."
sudo DEBIAN_FRONTEND=noninteractive apt-get purge -y "${packages[@]}" || true
sudo apt-get autoremove -y

echo
echo "GNOME removal attempted. If something breaks, you can reinstall ubuntu-desktop or gdm3."
