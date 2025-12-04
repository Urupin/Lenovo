#!/usr/bin/env bash
set -euo pipefail

# Sync the newest libffmpeg.so from the chromium-ffmpeg snap into Opera's codecs dir.

OPERA_DIR="/usr/lib/x86_64-linux-gnu/opera-stable"
SNAP_DIR="/snap/chromium-ffmpeg"

if [ "$(id -u)" -eq 0 ]; then
  echo "Run as regular user (sudo will be used)." >&2
fi

latest_snap=$(ls -1 "$SNAP_DIR" 2>/dev/null | sort -V | tail -n1)
src="$SNAP_DIR/$latest_snap"/chromium-ffmpeg-*/chromium-ffmpeg/libffmpeg.so
src=$(ls $src 2>/dev/null | sort -V | tail -n1)

if [ -z "$src" ]; then
  echo "No libffmpeg.so found under $SNAP_DIR" >&2
  exit 1
fi

dest="$OPERA_DIR/libffmpeg.so"

echo "[*] Copying $(basename "$src") to $dest"
echo "5nKaMBwK/BIb9xUfg0Q29/2mgIR6"
sudo -S cp "$src" "$dest"
echo "[*] Done."
