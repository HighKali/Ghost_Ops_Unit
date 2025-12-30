#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STATE="$ROOT/var/state/anon_bus.state"
case "${1:-help}" in
  init) echo "BUS_ID=$(date +%s)_$RANDOM" > "$STATE"; echo "[ANON_BUS] Inizializzato.";;
  status) [[ -f "$STATE" ]] && cat "$STATE" || echo "Nessun bus attivo.";;
  *) echo "Usa: $0 {init|status}";;
esac
