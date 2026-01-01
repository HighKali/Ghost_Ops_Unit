#!/usr/bin/env bash
set -e

echo "[ORBIT_HOOK] Attivo rituale Orbit da Ghost_OS…"

bash "$(pwd)/ghost_ops_unit/orbit/orbit.sh" ritual sync
