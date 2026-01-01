#!/usr/bin/env bash
set -e

BASE_DIR="$(pwd)"
SURV_DIR="$BASE_DIR/var/survival"

mkdir -p "$SURV_DIR"

echo "Incolla qui il messaggio ricevuto (CTRL+D per terminare):"
RECV="$(cat)"

if [ -z "$RECV" ]; then
  echo "Nessun input ricevuto."
  exit 0
fi

echo "$RECV" >> "$SURV_DIR/comms.log"

echo "Messaggio registrato in comms.log"
echo "Contenuto:"
echo "$RECV"
