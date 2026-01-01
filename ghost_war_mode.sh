#!/usr/bin/env bash
set -e

echo "====================================="
echo " GHOST WAR MODE — DIFENSIVO & ETICO"
echo "====================================="

BASE_DIR="$(pwd)"

echo "[1] Attivo modalità isolamento…"
# Disattiva servizi non essenziali (solo locali)
export GHOST_WAR_MODE=1

echo "[2] Attivo integrity guardian…"
bash "$BASE_DIR/core/integrity/verify_and_heal.sh" || true

echo "[3] Attivo ritual engine in modalità protetta…"
python3 "$BASE_DIR/ghost_os/ritual_engine/ritual_engine.py" --trigger war_mode 2>/dev/null || true

echo "[4] Attivo logging avanzato…"
mkdir -p "$BASE_DIR/var/logs_war"
echo "$(date) — WAR MODE ACTIVE" >> "$BASE_DIR/var/logs_war/war_mode.log"

echo "[5] Attivo monitoraggio passivo Orbit…"
bash "$BASE_DIR/ghost_ops_unit/orbit/orbit.sh" context || true

echo "[6] Sincronizzo Orbit ↔ Ghost_OS…"
bash "$BASE_DIR/ghost_ops_unit/orbit/orbit.sh" bridge || true

echo "[7] Attivo rituale di protezione…"
bash "$BASE_DIR/rituals/init_ritual.sh" || true

echo "[8] Attivo modalità blackout etico…"
# Nessuna rete attiva, nessuna scansione, nessun traffico
export GHOST_NETWORK_SILENT=1

echo "[9] Aggiorno dashboard di guerra…"
cp "$BASE_DIR/docs/architecture.html" "$BASE_DIR/docs/war_dashboard.html" 2>/dev/null || true

echo
echo "====================================="
echo " GHOST WAR MODE ATTIVO"
echo " Modalità: difensiva, passiva, etica"
echo "====================================="
