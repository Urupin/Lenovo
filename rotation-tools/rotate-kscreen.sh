#!/usr/bin/env bash
set -euo pipefail

# Rotate the primary panel (eDP-1) via kscreen-doctor.
# Usage: rotate-kscreen.sh normal|left|right|inverted

RAW=$(kscreen-doctor -o | sed -r 's/\x1B\[[0-9;]*[A-Za-z]//g')
OUT_ID=$(echo "$RAW" | awk '$1=="Output:" {print $2; exit}')
OUT_NAME=$(echo "$RAW" | awk '$1=="Output:" {print $3; exit}')
if [ -z "${OUT_ID:-}" ] && [ -z "${OUT_NAME:-}" ]; then
  echo "No output found via kscreen-doctor" >&2
  exit 1
fi

want="${1:-right}"
case "$want" in
  normal)    ROT_NUM="1"; ROT_WORD="normal" ;;
  right)     ROT_NUM="2"; ROT_WORD="right" ;;
  inverted)  ROT_NUM="3"; ROT_WORD="inverted" ;;
  left)      ROT_NUM="4"; ROT_WORD="left" ;;
  *) echo "Usage: $0 normal|left|right|inverted" >&2; exit 1 ;;
esac

# Prefer connector name if present (e.g., eDP-1)
OUT_PRIMARY=${OUT_NAME:-$OUT_ID}
OUT_FALLBACK=${OUT_ID:-$OUT_NAME}

try() { kscreen-doctor "$@" && return 0; return 1; }

echo "Trying rotation '$want' on output id/name: $OUT_PRIMARY ($OUT_FALLBACK)..."
if try "output.${OUT_PRIMARY}.rotation.${ROT_NUM}"; then exit 0; fi
if try "output.${OUT_PRIMARY}.rotation.${ROT_WORD}"; then exit 0; fi
if try "output.${OUT_FALLBACK}.rotation.${ROT_NUM}"; then exit 0; fi
if try "output.${OUT_FALLBACK}.rotation.${ROT_WORD}"; then exit 0; fi

echo "Failed to rotate via kscreen-doctor (id=$OUT_PRIMARY name=$OUT_FALLBACK, target=$want)" >&2
exit 1
