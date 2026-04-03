# TASK-001 — Criar endpoint de login

## Status
DONE

## Objetivo
Criar o endpoint POST /auth/login.

## Contexto
Esta task implementa a entrada principal do fluxo de autenticação.

## Dependências
- nenhuma

## Arquivos impactados
- src/controllers/auth.controller.ts
- src/services/auth.service.ts
- src/routes/auth.routes.ts

## Critérios de pronto
- endpoint criado
- validação de payload implementada
- resposta padronizada
- testes mínimos adicionados

## Testes sugeridos
- login com credenciais válidas
- login com senha inválida
- payload inválido

## Resultado
- endpoint implementado
- service criado
- testes iniciais adicionados

## Observações
- seguir o padrão atual de controllers
