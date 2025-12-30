#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TMP="$(mktemp -d -p "$ROOT/var/state" ghost_env_XXXX)"
mkdir -p "$TMP/runtime" "$TMP/tmp"
echo "[GHOST_BOOT] Ambiente effimero: $TMP"
