#!/usr/bin/env bash

# ============================================================
# Hook: check-task-tracking.sh
# ------------------------------------------------------------
# Para que serve:
# - roda quando o agente vai encerrar (stop)
# - usa a feature ativa detectada para validar o tracking
# - registra se existem tasks em DOING, TODO, BLOCKED, DONE
# - ajuda na retomada da próxima interação
#
# Observação:
# - esta versão não bloqueia o stop
# - ela registra contexto útil de auditoria
# - pode ser evoluída depois para negar/alertar de forma mais forte
# ============================================================

set -euo pipefail

is_valid_feature() {
  local val="${1:-}"
  printf '%s' "$val" | grep -qE '^[A-Za-z0-9_-]+$'
}

HOOK_PAYLOAD="$(cat || true)"

STATE_DIR=".cursor/state"
LOG_DIR=".cursor/logs"
STATE_FILE="${STATE_DIR}/active-feature.txt"
LOG_FILE="${LOG_DIR}/task-tracking.log"

mkdir -p "${STATE_DIR}" "${LOG_DIR}"

TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

FEATURE=""

# 1) tenta usar a feature persistida
if [ -f "${STATE_FILE}" ]; then
  FEATURE="$(flock -s -w 5 "${STATE_FILE}.lock" cat "${STATE_FILE}" | tr -d '\r' || true)"
  if [ -n "$FEATURE" ] && ! is_valid_feature "$FEATURE"; then
    echo "[$TIMESTAMP] WARN: Feature inválida no state file ignorada: ${FEATURE}" >> "${LOG_FILE}"
    FEATURE=""
  fi
fi

# 2) fallback: tentar detectar novamente a partir do payload / arquivos
if [ -z "${FEATURE}" ]; then
  FEATURE="$(".cursor/hooks/detect-active-feature.sh" "$HOOK_PAYLOAD" || true)"
  if [ -n "$FEATURE" ] && ! is_valid_feature "$FEATURE"; then
    echo "[$TIMESTAMP] WARN: Feature inválida detectada via script ignorada: ${FEATURE}" >> "${LOG_FILE}"
    FEATURE=""
  fi
fi

FEATURE="${FEATURE:-}"

TASK_DIR=""
INDEX_FILE=""

if [ -n "${FEATURE}" ]; then
  TASK_DIR="docs/tasks/${FEATURE}"
  INDEX_FILE="${TASK_DIR}/INDEX.md"
fi

count_status() {
  local dir="${1:-}"
  local wanted="${2:-}"
  local count=0
  local task_file=""
  local status=""
  shopt -s nullglob
  for task_file in "${dir}"/TASK-*.md; do
    [ -f "$task_file" ] || continue
    status="$(awk '/^## Status$/{getline; gsub(/\r/,""); print; exit}' "$task_file" || true)"
    if [ "$status" = "$wanted" ]; then
      count=$((count + 1))
    fi
  done
  printf '%s\n' "$count"
}

list_status_files() {
  local dir="${1:-}"
  local wanted="${2:-}"
  local task_file=""
  local status=""
  shopt -s nullglob
  for task_file in "${dir}"/TASK-*.md; do
    [ -f "$task_file" ] || continue
    status="$(awk '/^## Status$/{getline; gsub(/\r/,""); print; exit}' "$task_file" || true)"
    if [ "$status" = "$wanted" ]; then
      printf '%s\n' "$task_file"
    fi
  done
}

{
  echo "============================================================"
  echo "[$TIMESTAMP] stop hook executado"
  echo "Feature ativa detectada: ${FEATURE:-<nenhuma>}"

  if [ -n "${FEATURE}" ] && [ -d "${TASK_DIR}" ]; then
    TODO_COUNT="$(count_status "${TASK_DIR}" "TODO")"
    DOING_COUNT="$(count_status "${TASK_DIR}" "DOING")"
    BLOCKED_COUNT="$(count_status "${TASK_DIR}" "BLOCKED")"
    DONE_COUNT="$(count_status "${TASK_DIR}" "DONE")"

    echo "Diretório da feature: ${TASK_DIR}"
    echo "INDEX esperado: ${INDEX_FILE}"
    echo "Resumo das tasks:"
    echo "- TODO: ${TODO_COUNT}"
    echo "- DOING: ${DOING_COUNT}"
    echo "- BLOCKED: ${BLOCKED_COUNT}"
    echo "- DONE: ${DONE_COUNT}"

    if [ "${DOING_COUNT}" -gt 0 ]; then
      echo "Tasks ainda em DOING:"
      list_status_files "${TASK_DIR}" "DOING"
      echo "Observação: revisar se alguma task deveria ter sido finalizada como DONE ou BLOCKED."
    fi

    if [ ! -f "${INDEX_FILE}" ]; then
      echo "Atenção: INDEX.md da feature não foi encontrado."
    fi
  else
    echo "Nenhuma feature ativa pôde ser determinada."
  fi

  echo "Payload resumido:"
  printf '%s\n' "$HOOK_PAYLOAD" | head -c 1500
  echo
} >> "${LOG_FILE}"

echo "{}"
exit 0
