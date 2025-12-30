#!/usr/bin/env bash
set -e

echo "[BOOTSTRAP] Creazione struttura Ghost_OS..."

mkdir -p core/{ghost_boot,integrity,anon_bus,notify,packaging,security,logging,profile}
mkdir -p rituals ops missions/templates docs var/logs var/state
touch var/logs/.gitkeep var/state/.gitkeep

echo "[BOOTSTRAP] Scrittura file..."

# MANIFESTO.md
cat > MANIFESTO.md << 'EOM'
# Ghost Ops Unit – Ordine Fantasma
Ghost_Ops_Unit è un sistema operativo rituale per cyber difesa, resilienza e automazione etica.
EOM

# README.md
cat > README.md << 'EOM'
# Ghost_Ops_Unit – Ghost Cyber Defence OS
Sistema operativo effimero, modulare e rituale per cyber difesa legale.
EOM

# .env.example
cat > .env.example << 'EOM'
GHOST_PROFILE="DEV"
GHOST_NODE_ID="ghost-node-001"
TELEGRAM_BOT_TOKEN=""
TELEGRAM_CHAT_ID=""
MATRIX_HOMESERVER_URL=""
MATRIX_ACCESS_TOKEN=""
MATRIX_ROOM_ID=""
NODE_RECEIVE_SECRET=""
EOM

# core/profile/profile_resolver.sh
cat > core/profile/profile_resolver.sh << 'EOM'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[[ -f "$ROOT/.env" ]] && source "$ROOT/.env"
case "${GHOST_PROFILE:-DEV}" in DEV|LAB|FIELD) echo "$GHOST_PROFILE";; *) echo "DEV";; esac
EOM

# core/integrity/verify_and_heal.sh
cat > core/integrity/verify_and_heal.sh << 'EOM'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
for d in core rituals ops var/logs var/state missions; do mkdir -p "$ROOT/$d"; done
echo "[INTEGRITY] Struttura minima garantita."
EOM

# core/ghost_boot/ghost_boot.sh
cat > core/ghost_boot/ghost_boot.sh << 'EOM'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TMP="$(mktemp -d -p "$ROOT/var/state" ghost_env_XXXX)"
mkdir -p "$TMP/runtime" "$TMP/tmp"
echo "[GHOST_BOOT] Ambiente effimero: $TMP"
EOM

# core/anon_bus/anon_bus.sh
cat > core/anon_bus/anon_bus.sh << 'EOM'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STATE="$ROOT/var/state/anon_bus.state"
case "${1:-help}" in
  init) echo "BUS_ID=$(date +%s)_$RANDOM" > "$STATE"; echo "[ANON_BUS] Inizializzato.";;
  status) [[ -f "$STATE" ]] && cat "$STATE" || echo "Nessun bus attivo.";;
  *) echo "Usa: $0 {init|status}";;
esac
EOM

# core/notify/notify_startup.sh
cat > core/notify/notify_startup.sh << 'EOM'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[[ -f "$ROOT/.env" ]] && source "$ROOT/.env"
MSG="[GHOST_OPS] Nodo: ${GHOST_NODE_ID:-ghost} | Avvio"
[[ -n "$TELEGRAM_BOT_TOKEN" ]] && curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" -d "chat_id=${TELEGRAM_CHAT_ID}" -d "text=${MSG}" >/dev/null
EOM

# core/packaging/package_snapshot.sh
cat > core/packaging/package_snapshot.sh << 'EOM'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT="$ROOT/var/state/packages"
mkdir -p "$OUT"
NAME="ghost_$(date +%Y%m%d_%H%M%S)_$RANDOM.tar.gz"
tar --exclude='.git' --exclude='var/logs' -czf "$OUT/$NAME" -C "$ROOT" .
sha256sum "$OUT/$NAME" > "$OUT/$NAME.sha256"
echo "[LYRA] Pacchetto creato: $OUT/$NAME"
EOM

# core/security/validate_node_receive.sh
cat > core/security/validate_node_receive.sh << 'EOM'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[[ -f "$ROOT/.env" ]] && source "$ROOT/.env"
[[ "$1" == "$NODE_RECEIVE_SECRET" ]] && exit 0 || exit 1
EOM

# core/logging/eco_log.py
cat > core/logging/eco_log.py << 'EOM'
#!/usr/bin/env python3
import os, sys, json
from datetime import datetime
ROOT=os.path.abspath(os.path.join(os.path.dirname(__file__),"..",".."))
LOG=os.path.join(ROOT,"var","logs")
os.makedirs(LOG,exist_ok=True)
if len(sys.argv)<3: sys.exit(1)
entry={"ts":datetime.utcnow().isoformat()+"Z","channel":sys.argv[1],"msg":" ".join(sys.argv[2:])}
with open(os.path.join(LOG,f"{sys.argv[1]}.log"),"a") as f: f.write(json.dumps(entry)+"\n")
print(entry)
EOM

# rituals/init_ritual.sh
cat > rituals/init_ritual.sh << 'EOM'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bash "$ROOT/core/integrity/verify_and_heal.sh"
bash "$ROOT/core/ghost_boot/ghost_boot.sh"
bash "$ROOT/core/anon_bus/anon_bus.sh" init
python3 "$ROOT/core/logging/eco_log.py" rituals "init_ritual_started"
EOM

# rituals/closure_ritual.sh
cat > rituals/closure_ritual.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 "$ROOT/core/logging/eco_log.py" rituals "closure_ritual"
EOM

# rituals/purge_ritual.sh
cat > rituals/purge_ritual.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
find "$ROOT/var/state" -type d -name 'ghost_env_*' -exec rm -rf {} +
echo "[PURGE] Ambienti effimeri rimossi."
EOM

# ops/ghost_status.sh
cat > ops/ghost_status.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "=== Ghost Status ==="
ls -1t "$ROOT/var/logs" | head -n 5
bash "$ROOT/core/anon_bus/anon_bus.sh" status
EOM

# ops/ghost_summary.sh
cat > ops/ghost_summary.sh << 'EOM'
#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tail -n 10 "$ROOT/var/logs/rituals.log" 2>/dev/null
tail -n 10 "$ROOT/var/logs/missions.log" 2>/dev/null
EOM

# ops/ghost_tmux.sh
cat > ops/ghost_tmux.sh << 'EOM'
#!/usr/bin/env bash
tmux new-session -d -s ghost "ghost"
tmux split-window -v "watch -n 5 ghost_status"
tmux split-window -h "tail -F var/logs/rituals.log"
tmux attach -t ghost
EOM

# missions/network_hygiene.sh
cat > missions/network_hygiene.sh << 'EOM'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 "$ROOT/core/logging/eco_log.py" missions "mission_start network_hygiene"
ip addr show > "$ROOT/var/state/ip_info.txt"
arp -a > "$ROOT/var/state/arp_table.txt"
netstat -tulnp > "$ROOT/var/state/open_ports.txt"
python3 "$ROOT/core/logging/eco_log.py" missions "mission_end network_hygiene"
EOM

echo "[BOOTSTRAP] Permessi..."
chmod -R +x core rituals ops missions

echo "[BOOTSTRAP] Commit Git..."
git add .
git commit -m "Bootstrap Ghost_OS completo"
echo "[BOOTSTRAP] Fatto."
