#!/usr/bin/env bash
set -euo pipefail

# Absolute path to rotate-wayland.py in the same directory as this script.
SCRIPT="$(readlink -f "$(dirname "$0")/rotate-wayland.py")"
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
