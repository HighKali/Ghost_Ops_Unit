#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[[ -f "$ROOT/.env" ]] && source "$ROOT/.env"
MSG="[GHOST_OPS] Nodo: ${GHOST_NODE_ID:-ghost} | Avvio"
[[ -n "$TELEGRAM_BOT_TOKEN" ]] && curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" -d "chat_id=${TELEGRAM_CHAT_ID}" -d "text=${MSG}" >/dev/null
