#!/usr/bin/env bash
set -e

PORT="$1"
BAUD="$2"

if [ -z "$PORT" ] || [ -z "$BAUD" ]; then
  echo "Uso: ghost_cb_terminal.sh /dev/ttyS0 9600"
  exit 1
fi

echo "Apro terminale su $PORT a $BAUD baud."
echo "CTRL+C per uscire."

stty -F "$PORT" "$BAUD" cs8 -cstopb -parenb -ixon -ixoff -crtscts 2>/dev/null || true

while true; do
  if read -r LINE; then
    printf "%s\n" "$LINE" > "$PORT"
  fi &
  cat "$PORT"
done
