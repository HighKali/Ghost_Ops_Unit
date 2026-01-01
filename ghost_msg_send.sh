#!/usr/bin/env bash
set -e

BASE_DIR="$(pwd)"
SURV_DIR="$BASE_DIR/var/survival"

mkdir -p "$SURV_DIR"

read -rp "ID mittente: " FROM
read -rp "ID destinatario: " TO
read -rp "Canale (telnet/seriale): " CH
read -rp "Messaggio: " MSG

TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
LINE="FROM=$FROM|TO=$TO|TS=$TS|MSG=$MSG"

echo "$LINE" >> "$SURV_DIR/comms.log"

echo "Messaggio formattato:"
echo "$LINE"

echo "Invio manuale richiesto:"
echo "- Se telnet: incolla questa riga nella sessione."
echo "- Se seriale: usa ghost_cb_terminal.sh e incolla la riga."
