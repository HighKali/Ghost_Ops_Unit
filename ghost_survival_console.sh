#!/usr/bin/env bash
set -e

BASE_DIR="$(pwd)"
SURV_DIR="$BASE_DIR/var/survival"

mkdir -p "$SURV_DIR"

while true; do
  clear
  echo "====================================="
  echo " GHOST SURVIVAL CONSOLE"
  echo "====================================="
  echo "1) Invia messaggio"
  echo "2) Ricevi messaggi"
  echo "3) Terminale CB/Seriale"
  echo "4) Stato sistema"
  echo "5) Rituali essenziali"
  echo "6) Esci"
  echo "-------------------------------------"
  read -rp "Scelta: " CHOICE

  case "$CHOICE" in
    1)
      bash "$BASE_DIR/ghost_msg_send.sh"
      read -rp "Premi invio per continuare…" ;;
    2)
      bash "$BASE_DIR/ghost_msg_recv.sh"
      read -rp "Premi invio per continuare…" ;;
    3)
      read -rp "Porta seriale (es. /dev/ttyS0): " PORT
      read -rp "Baud (es. 9600): " BAUD
      bash "$BASE_DIR/ghost_cb_terminal.sh" "$PORT" "$BAUD"
      read -rp "Premi invio per continuare…" ;;
    4)
      echo "---- STATO SISTEMA ----"
      date
      echo "Directory: $BASE_DIR"
      echo "Survival dir: $SURV_DIR"
      echo "Log comunicazioni:"
      tail -n 10 "$SURV_DIR/comms.log" 2>/dev/null || echo "Nessun log."
      echo "------------------------"
      read -rp "Premi invio per continuare…" ;;
    5)
      echo "---- RITUALI ESSENZIALI ----"
      if [ -x "$BASE_DIR/rituals/init_ritual.sh" ]; then
        echo "Eseguo init_ritual.sh…"
        bash "$BASE_DIR/rituals/init_ritual.sh" || true
      fi
      if [ -x "$BASE_DIR/rituals/closure_ritual.sh" ]; then
        echo "Eseguo closure_ritual.sh…"
        bash "$BASE_DIR/rituals/closure_ritual.sh" || true
      fi
      if [ -x "$BASE_DIR/rituals/purge_ritual.sh" ]; then
        echo "Eseguo purge_ritual.sh…"
        bash "$BASE_DIR/rituals/purge_ritual.sh" || true
      fi
      echo "-----------------------------"
      read -rp "Premi invio per continuare…" ;;
    6)
      echo "Uscita dalla Survival Console."
      exit 0 ;;
    *)
      echo "Scelta non valida."
      sleep 1 ;;
  esac
done
