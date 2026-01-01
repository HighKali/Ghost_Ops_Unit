#!/usr/bin/env bash
set -e

BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

echo "[RITUAL_SYNC] Attivo ritual engine Ghost_OS…"

python3 "$BASE_DIR/../../ghost_os/ritual_engine/ritual_engine.py" --trigger orbit_sync 2>/dev/null || true

echo "[RITUAL_SYNC] Completato."
