#!/usr/bin/env bash
set -e

BASE_DIR="$(pwd)"

echo "Attivo modalità SOLO TESTO…"

export GHOST_TEXT_ONLY=1

echo "Disattivo componenti non essenziali (solo logico, nessun servizio viene toccato automaticamente)."
echo "Usa solo:"
echo "- ghost_survival_console.sh"
echo "- ghost_cb_terminal.sh"
echo "- ghost_msg_send.sh / ghost_msg_recv.sh"

echo "Modalità solo testo attiva."
