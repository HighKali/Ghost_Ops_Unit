#!/usr/bin/env bash
set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

GHOST_NAME="Ghost_Ops_Unit"
GHOST_CODENAME="Ghost Orbit System"
GHOST_VERSION="1.0-alpha"
GHOST_MODE="${GHOST_MODE:-normal}"

CONFIG_FILE="$BASE_DIR/ghost_config.env"
INTEGRITY_MANIFEST="$BASE_DIR/ghost_integrity_manifest.txt"
LOG_DIR="$BASE_DIR/var/logs"
HEALTH_LOG="$LOG_DIR/healthcheck.log"

mkdir -p "$LOG_DIR"

banner() {
  echo "===================================================="
  echo "  $GHOST_NAME  —  $GHOST_CODENAME"
  echo "  Mode: $GHOST_MODE   Version: $GHOST_VERSION"
  echo "  Base: $BASE_DIR"
  echo "===================================================="
}

load_config() {
  if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
  fi
}

define_default_config() {
  if [ -f "$CONFIG_FILE" ]; then
    return
  fi
  cat > "$CONFIG_FILE" <<EOF
# Ghost_Ops_Unit core configuration

GHOST_MODE=normal
GHOST_TEXT_ONLY=0
GHOST_WAR_MODE=0
GHOST_ORBIT_SYNC=1
GHOST_TAMPER_ALERT=1
GHOST_HEALTHCHECK_INTERVAL=300
EOF
  echo "[CONFIG] Creato ghost_config.env con valori di default."
}

check_core_dirs() {
  echo "[CHECK] Verifica directory core..."
  local missing=0
  for d in \
    ghost_onion_node \
    ghost_orbit_client \
    ghost_peripheral \
    ghost_orbit_engine \
    ghost_rituals \
    ghost_dashboard \
    ghost_superguardian \
    var/survival \
    var/logs_war \
    ghost_os \
    ghost_ops_unit \
    ; do
    if [ ! -d "$BASE_DIR/$d" ]; then
      echo "[WARN] Directory mancante: $d"
      missing=1
    else
      echo "[OK]   $d"
    fi
  done
  return $missing
}

build_integrity_manifest() {
  echo "[INTEGRITY] Genero manifest..."
  cat > "$INTEGRITY_MANIFEST" <<EOF
# Ghost_Ops_Unit integrity manifest
# Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
EOF

  critical_files=(
    "ghost_ops_unit.sh"
    "ghost_war_mode.sh"
    "ghost_survival_console.sh"
    "ghost_cb_terminal.sh"
    "ghost_msg_send.sh"
    "ghost_msg_recv.sh"
    "ghost_text_only_mode.sh"
    "ghost_ops_unit/orbit/orbit.sh"
    "ghost_ops_unit/orbit/engine/sync_bridge.sh"
    "ghost_os/ritual_engine/ritual_engine.py"
    "ghost_os/ritual_engine/orbit_hook.sh"
  )

  for f in "${critical_files[@]}"; do
    if [ -f "$BASE_DIR/$f" ]; then
      sha256sum "$BASE_DIR/$f" >> "$INTEGRITY_MANIFEST"
    fi
  done

  echo "[INTEGRITY] Manifest aggiornato: $INTEGRITY_MANIFEST"
}

verify_integrity() {
  if [ ! -f "$INTEGRITY_MANIFEST" ]; then
    echo "[INTEGRITY] Manifest assente. Esegui: $0 integrity-build"
    return 1
  fi
  echo "[INTEGRITY] Verifica integrità file critici..."
  if sha256sum -c "$INTEGRITY_MANIFEST"; then
    echo "[INTEGRITY] Tutto coerente."
  else
    echo "[ALERT] Integrità compromessa!"
    echo "$(date) — INTEGRITY ALERT" >> "$HEALTH_LOG"
    if [ "${GHOST_TAMPER_ALERT:-1}" = "1" ]; then
      if [ -x "$BASE_DIR/ghost_war_mode.sh" ]; then
        echo "[ALERT] Attivo War Mode per protezione."
        bash "$BASE_DIR/ghost_war_mode.sh" || true
      fi
    fi
    return 1
  fi
}

check_permissions() {
  echo "[CHECK] Permessi pericolosi..."
  local bad=0
  while IFS= read -r path; do
    [ -z "$path" ] && continue
    echo "[WARN] Permessi troppo aperti: $path"
    bad=1
  done < <(find "$BASE_DIR" -type f -perm -002 -maxdepth 6 2>/dev/null || true)
  if [ "$bad" -eq 0 ]; then
    echo "[OK] Nessun file con permessi scrivibili da altri."
  fi
}

healthcheck() {
  banner
  load_config
  define_default_config

  echo "[HEALTH] Avvio healthcheck..."
  {
    echo "===== HEALTHCHECK $(date) ====="
    check_core_dirs || echo "[HEALTH] Directory mancanti rilevate."
    check_permissions
    verify_integrity || echo "[HEALTH] Integrità non perfetta."
    echo
  } | tee -a "$HEALTH_LOG"
  echo "[HEALTH] Log: $HEALTH_LOG"
}

info() {
  banner
  echo "[INFO] Moduli principali:"
  cat <<EOF
  - Ghost Onion Node       -> ghost_onion_node/
  - Ghost Orbit Client     -> ghost_orbit_client/
  - Ghost Peripheral       -> ghost_peripheral/
  - Ghost Orbit Engine     -> ghost_orbit_engine/
  - Ghost Rituals          -> ghost_rituals/
  - Ghost Dashboard        -> ghost_dashboard/
  - Ghost Superguardian    -> ghost_superguardian/
  - Survival Pack          -> ghost_survival_console.sh, var/survival/
  - War Mode               -> ghost_war_mode.sh, var/logs_war/
  - Orbit Bridge           -> ghost_ops_unit/orbit/engine/sync_bridge.sh
EOF
}

map() {
  banner
  echo "[MAP] Schema orbitale di Ghost_Ops_Unit:"
  echo
  cat <<'EOF'
                         ┌───────────────────────┐
                         │    Ghost Onion Node    │
                         │     (Privacy Core)     │
                         └────────────┬───────────┘
                                      │
                   ┌──────────────────┼──────────────────┐
                   │                  │                  │
        ┌──────────▼──────────┐   ┌──▼───────────┐   ┌──▼─────────────┐
        │  Ghost Orbit Client  │   │ Ghost Peripheral │ │ Ghost Dashboard │
        │ (Satellite Operativo)│   │ (Sensori Passivi)│ │ (Interfaccia)  │
        └──────────┬──────────┘   └────────┬────────┘ └────────┬────────┘
                   │                        │                   │
                   │                        │                   │
             ┌─────▼────────────────────────▼───────────────────▼──────┐
             │                   Ghost Orbit Engine                     │
             │         (Motore di Sincronizzazione Orbitale)           │
             └───────────┬─────────────────────────────────────────────┘
                         │
                         │
             ┌───────────▼──────────────┐
             │      Ghost Rituals        │
             │ (Ritual Engine / Hooks)   │
             └───────────┬──────────────┘
                         │
                         │
             ┌───────────▼──────────────┐
             │         Ghost_OS          │
             │ (Sistema Difensivo Etico) │
             └───────────┬──────────────┘
                         │
        ┌────────────────┼───────────────────────────────┐
        │                │                               │
┌───────▼────────┐ ┌─────▼──────────────┐       ┌────────▼──────────┐
│  Survival Pack  │ │      War Mode      │       │  Superguardian     │
│ (Offline Mode)  │ │ (Isolamento Etico) │       │ (Integrity Watch)  │
└─────────────────┘ └────────────────────┘       └────────────────────┘

EOF
}

define() {
  banner
  load_config
  define_default_config
  echo "[DEFINE] $GHOST_NAME è definito come:"
  echo "  Codename: $GHOST_CODENAME"
  echo "  Versione: $GHOST_VERSION"
  echo "  Modalità: $GHOST_MODE"
  echo
  echo "[DEFINE] Config: $CONFIG_FILE"
  echo "[DEFINE] Manifest integrità: $INTEGRITY_MANIFEST"
  echo "[DEFINE] Log salute: $HEALTH_LOG"
}

usage() {
  banner
  cat <<EOF
Uso: $0 <comando>

Comandi disponibili:
  trace            — Analisi OSINT difensiva delle tue tracce
  define           — Definisce e presenta Ghost_Ops_Unit
  health           — Esegue healthcheck completo
  integrity-build  — Genera/aggiorna il manifest di integrità
  integrity-check  — Verifica integrità file critici
  info             — Mostra info su moduli e struttura
  map              — Mostra la mappa orbitale ASCII
  help             — Mostra questo messaggio
EOF
}

cmd="$1"
case "$cmd" in
  define) define ;;
  health) healthcheck ;;
  integrity-build) build_integrity_manifest ;;
  integrity-check) verify_integrity ;;
  info) info ;;
  trace)
    bash "$BASE_DIR/ghost_trace_shield.sh"
    ;;
  map) map ;;
  help|"") usage ;;
  *)
    echo "[ERROR] Comando sconosciuto: $cmd"
    usage
    exit 1
    ;;
esac
