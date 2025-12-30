#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 "$ROOT/core/logging/eco_log.py" missions "mission_start network_hygiene"
ip addr show > "$ROOT/var/state/ip_info.txt"
arp -a > "$ROOT/var/state/arp_table.txt"
netstat -tulnp > "$ROOT/var/state/open_ports.txt"
python3 "$ROOT/core/logging/eco_log.py" missions "mission_end network_hygiene"
