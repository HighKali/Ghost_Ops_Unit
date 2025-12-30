#!/usr/bin/env bash
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "=== Ghost Status ==="
ls -1t "$ROOT/var/logs" | head -n 5
bash "$ROOT/core/anon_bus/anon_bus.sh" status
