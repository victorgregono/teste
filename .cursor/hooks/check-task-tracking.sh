#!/usr/bin/env bash

# ============================================================
# Hook: check-task-tracking.sh
# ------------------------------------------------------------
# Para que serve:
# - roda quando o agente vai encerrar (evento "stop")
# - verifica se existem tasks ainda marcadas como DOING
# - registra um log simples para auditoria
#
# Observação:
# - este script não bloqueia o agente
# - ele serve como MVP de rastreabilidade
# - depois você pode evoluir para algo mais rígido
# ============================================================

set -euo pipefail

# Consome o JSON do hook via stdin para evitar travamento
HOOK_PAYLOAD="$(cat || true)"

LOG_DIR=".cursor/logs"
LOG_FILE="${LOG_DIR}/task-tracking.log"

mkdir -p "${LOG_DIR}"

TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

# Procura por tasks com status DOING
DOING_TASKS="$(grep -R -l '^## Status$' docs/tasks 2>/dev/null | while read -r file; do
  next_line="$(awk '/^## Status$/{getline; print; exit}' "$file" | tr -d '\r')"
  if [ "$next_line" = "DOING" ]; then
    echo "$file"
  fi
done || true)"

{
  echo "============================================================"
  echo "[$TIMESTAMP] stop hook executado"
  echo "Payload resumido capturado com sucesso."
  if [ -n "${DOING_TASKS}" ]; then
    echo "Tasks ainda em DOING:"
    echo "${DOING_TASKS}"
    echo "Observação: revisar se alguma task deveria ter sido finalizada como DONE ou BLOCKED."
  else
    echo "Nenhuma task encontrada em DOING."
  fi
} >> "${LOG_FILE}"

# Retorno vazio em JSON
echo "{}"
exit 0
