#!/usr/bin/env bash

# ============================================================
# Hook: post-edit-check.sh
# ------------------------------------------------------------
# Para que serve:
# - roda após o agente editar um arquivo (afterFileEdit)
# - detecta a feature ativa usando detect-active-feature.sh
# - salva a feature ativa em .cursor/state/active-feature.txt
# - registra auditoria em log
#
# Observação:
# - não altera tasks automaticamente
# - apenas detecta contexto e persiste estado auxiliar
# ============================================================

set -euo pipefail

HOOK_PAYLOAD="$(cat || true)"

STATE_DIR=".cursor/state"
LOG_DIR=".cursor/logs"
STATE_FILE="${STATE_DIR}/active-feature.txt"
LOG_FILE="${LOG_DIR}/post-edit.log"

mkdir -p "${STATE_DIR}" "${LOG_DIR}"

TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

FEATURE="$(".cursor/hooks/detect-active-feature.sh" "$HOOK_PAYLOAD" || true)"
FEATURE="${FEATURE:-}"

# Validar que FEATURE contém apenas caracteres permitidos (whitelist)
if [ -n "$FEATURE" ] && ! printf '%s' "$FEATURE" | grep -qE '^[A-Za-z0-9_-]+$'; then
  echo "[$TIMESTAMP] AVISO: valor de FEATURE inválido descartado: '${FEATURE}'" >> "${LOG_FILE}"
  FEATURE=""
fi

if [ -n "$FEATURE" ]; then
  (
    flock -x -w 5 200 || { echo "[$TIMESTAMP] flock timeout na escrita" >> "${LOG_FILE}"; exit 0; }
    printf '%s\n' "$FEATURE" > "${STATE_FILE}"
  ) 200>"${STATE_FILE}.lock"
fi

{
  echo "============================================================"
  echo "[$TIMESTAMP] afterFileEdit hook executado"
  echo "Feature detectada: ${FEATURE:-<nenhuma>}"
  echo "Payload resumido:"
  printf '%s\n' "$HOOK_PAYLOAD" | head -c 1500
  echo
} >> "${LOG_FILE}"

# Retorno JSON vazio para o Cursor
echo "{}"
exit 0
