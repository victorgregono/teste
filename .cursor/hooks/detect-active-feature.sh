#!/usr/bin/env bash

# ============================================================
# Script auxiliar: detect-active-feature.sh
# ------------------------------------------------------------
# Para que serve:
# - detectar automaticamente a feature ativa
# - pode ser chamado por outros hooks
#
# Estratégia:
# 1) tentar extrair do payload do hook
# 2) procurar tasks em DOING
# 3) procurar feature mais recentemente alterada em docs/tasks/
#
# Saída:
# - imprime no stdout o nome da feature detectada
# - se não encontrar nada, imprime vazio
# ============================================================

set -euo pipefail

PAYLOAD="${1:-}"
if [ -z "${PAYLOAD}" ] && [ ! -t 0 ]; then
  PAYLOAD="$(cat || true)"
fi

sanitize_feature() {
  local raw="${1:-}"
  raw="$(printf '%s' "$raw" | tr -d '\r' | sed 's#^/*##; s#/*$##')"
  # remove sufixos conhecidos
  raw="${raw%-PRD.md}"
  raw="${raw%-ARCHITECTURE-PLAN.md}"
  raw="${raw%-PLAN.md}"
  # ignora templates e vazios
  case "$raw" in
    ""|TEMPLATE*|INDEX|tasks|prd|architecture)
      return 1
      ;;
  esac
  printf '%s\n' "$raw"
}

extract_from_payload() {
  local payload="${1:-}"
  local candidate=""

  # Ex.: docs/tasks/FEATURE-X/TASK-001.md ou docs/tasks/FEATURE-X/INDEX.md
  candidate="$(printf '%s' "$payload" \
    | grep -oE 'docs/tasks/[^/"[:space:]]+/' \
    | head -n1 \
    | sed -E 's#docs/tasks/([^/]+)/#\1#' || true)"
  if sanitize_feature "$candidate" >/dev/null 2>&1; then
    sanitize_feature "$candidate"
    return 0
  fi

  # Ex.: docs/prd/FEATURE-X-PRD.md
  candidate="$(printf '%s' "$payload" \
    | grep -oE 'docs/prd/[^/"[:space:]]+-PRD\.md' \
    | head -n1 \
    | sed -E 's#docs/prd/(.*)-PRD\.md#\1#' || true)"
  if sanitize_feature "$candidate" >/dev/null 2>&1; then
    sanitize_feature "$candidate"
    return 0
  fi

  # Ex.: docs/architecture/FEATURE-X-ARCHITECTURE-PLAN.md
  candidate="$(printf '%s' "$payload" \
    | grep -oE 'docs/architecture/[^/"[:space:]]+-ARCHITECTURE-PLAN\.md' \
    | head -n1 \
    | sed -E 's#docs/architecture/(.*)-ARCHITECTURE-PLAN\.md#\1#' || true)"
  if sanitize_feature "$candidate" >/dev/null 2>&1; then
    sanitize_feature "$candidate"
    return 0
  fi

  return 1
}

find_doing_feature() {
  local task_file=""
  local status=""
  shopt -s nullglob
  for task_file in docs/tasks/*/TASK-*.md; do
    [ -f "$task_file" ] || continue
    status="$(awk '/^## Status$/{getline; gsub(/\r/,""); print; exit}' "$task_file" || true)"
    if [ "$status" = "DOING" ]; then
      basename "$(dirname "$task_file")"
      return 0
    fi
  done
  return 1
}

find_recent_feature() {
  local recent=""
  recent="$(find docs/tasks -mindepth 2 -maxdepth 2 -type f \
    \( -name 'TASK-*.md' -o -name 'INDEX.md' \) \
    2>/dev/null \
    -printf '%T@ %p\n' \
    | sort -nr \
    | head -n1 \
    | cut -d' ' -f2- || true)"
  if [ -n "$recent" ]; then
    basename "$(dirname "$recent")"
    return 0
  fi
  return 1
}

main() {
  local feature=""

  if feature="$(extract_from_payload "$PAYLOAD" 2>/dev/null)"; then
    printf '%s\n' "$feature"
    exit 0
  fi

  if feature="$(find_doing_feature 2>/dev/null)"; then
    printf '%s\n' "$feature"
    exit 0
  fi

  if feature="$(find_recent_feature 2>/dev/null)"; then
    printf '%s\n' "$feature"
    exit 0
  fi

  printf '\n'
}

main
