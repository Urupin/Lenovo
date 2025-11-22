#!/usr/bin/env bash
set -euo pipefail

SCRIPT="/home/s/soft/Lenovo/rotate-wayland.py"
BASE="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
SCHEMA="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"

declare -a ENTRIES=(
  "rotate-left:<Super><Ctrl><Alt>Left:left"
  "rotate-right:<Super><Ctrl><Alt>Right:right"
  "rotate-normal:<Super><Ctrl><Alt>Up:normal"
  "rotate-inverted:<Super><Ctrl><Alt>Down:inverted"
)

paths=()
for entry in "${ENTRIES[@]}"; do
  IFS=":" read -r name binding arg <<<"$entry"
  path="$BASE/$name/"
  paths+=("'$path'")
  gsettings set "${SCHEMA}:${path}" name "$name"
  gsettings set "${SCHEMA}:${path}" command "$SCRIPT $arg"
  gsettings set "${SCHEMA}:${path}" binding "$binding"
done

joined=$(IFS=, ; echo "${paths[*]}")
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[$joined]"

echo "Горячие клавиши настроены:"
printf "  %s\n" "${ENTRIES[@]}"
