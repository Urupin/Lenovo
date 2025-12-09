#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="${ROOT}/build"
PREFIX="${HOME}/.local"

echo "==> Configure"
cmake -B "${BUILD_DIR}" -S "${ROOT}" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${PREFIX}"

echo "==> Build"
cmake --build "${BUILD_DIR}"

echo "==> Install to ${PREFIX}"
cmake --install "${BUILD_DIR}"

echo "==> Refresh KWin"
qdbus6 org.kde.KWin /KWin reconfigure || true

echo "Done. Если темы не видно, перезапустите KWin или сессию."
