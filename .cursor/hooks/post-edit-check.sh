#!/usr/bin/env bash

# ============================================================
# Hook: post-edit-check.sh
# ------------------------------------------------------------
# Para que serve:
# - roda após o agente editar um arquivo (evento "afterFileEdit")
# - registra um log simples de auditoria
# - pode ser evoluído depois para rodar lint/format/checks rápidos
# ============================================================

set -euo pipefail

HOOK_PAYLOAD="$(cat || true)"

LOG_DIR=".cursor/logs"
LOG_FILE="${LOG_DIR}/post-edit.log"

mkdir -p "${LOG_DIR}"

TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

{
  echo "============================================================"
  echo "[$TIMESTAMP] afterFileEdit hook executado"
  echo "Payload recebido:"
  echo "${HOOK_PAYLOAD}"
} >> "${LOG_FILE}"

# Exemplo opcional:
# Se quiser evoluir depois, você pode tentar rodar algo como:
# npm run lint -- --quiet || true

echo "{}"
exit 0
