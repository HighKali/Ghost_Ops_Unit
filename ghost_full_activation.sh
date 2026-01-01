#!/usr/bin/env bash
set -e

echo "[GHOST_FULL] Avvio rito completo Ghost_OS..."

# 1. Ritual di init (se esiste)
if [ -f rituals/init_ritual.sh ]; then
  echo "[GHOST_FULL] Ritual: init_ritual.sh"
  bash rituals/init_ritual.sh || echo "[WARN] init_ritual.sh fallito"
fi

# 2. Core bootstrap (se esiste)
if [ -f core/ghost_boot/ghost_boot.sh ]; then
  echo "[GHOST_FULL] Core: ghost_boot.sh"
  bash core/ghost_boot/ghost_boot.sh || echo "[WARN] ghost_boot.sh fallito"
fi

# 3. Esegui tutti i moduli ghost_os/*/module.py
echo "[GHOST_FULL] Eseguo tutti i moduli Ghost_OS..."
for m in ghost_os/*/module.py; do
  [ -e "$m" ] || continue
  MOD_NAME=$(basename "$(dirname "$m")")
  echo "[GHOST_FULL] Modulo: $MOD_NAME"
  python "$m" || echo "[WARN] Modulo $MOD_NAME ha dato errore"
done

# 4. Ritual engine test (se presente)
if [ -f ghost_os/ritual_engine/test_event.py ]; then
  echo "[GHOST_FULL] Ritual Engine: test_event.py"
  python ghost_os/ritual_engine/test_event.py || echo "[WARN] Ritual Engine test fallito"
fi

# 5. Ops: status, summary, doctor (se esistono)
if [ -f ops/ghost_status.sh ]; then
  echo "[GHOST_FULL] Ops: ghost_status.sh"
  bash ops/ghost_status.sh || echo "[WARN] ghost_status.sh fallito"
fi

if [ -f ops/ghost_summary.sh ]; then
  echo "[GHOST_FULL] Ops: ghost_summary.sh"
  bash ops/ghost_summary.sh || echo "[WARN] ghost_summary.sh fallito"
fi

if [ -f ops/ghost_doctor.sh ]; then
  echo "[GHOST_FULL] Ops: ghost_doctor.sh"
  bash ops/ghost_doctor.sh || echo "[WARN] ghost_doctor.sh fallito"
fi

# 6. Rigenera il sito (se script presenti)
if [ -f ghost_build_site.sh ]; then
  echo "[GHOST_FULL] Site: ghost_build_site.sh"
  bash ghost_build_site.sh || echo "[WARN] ghost_build_site.sh fallito"
elif [ -f ghost_site_builder.sh ]; then
  echo "[GHOST_FULL] Site: ghost_site_builder.sh"
  bash ghost_site_builder.sh || echo "[WARN] ghost_site_builder.sh fallito"
fi

# 7. Ritual di chiusura (se esiste)
if [ -f rituals/closure_ritual.sh ]; then
  echo "[GHOST_FULL] Ritual: closure_ritual.sh"
  bash rituals/closure_ritual.sh || echo "[WARN] closure_ritual.sh fallito"
fi

echo
echo "[GHOST_FULL] Rito completo eseguito."
echo "Heartbeat, log, moduli, ops e sito dovrebbero essere allineati."
