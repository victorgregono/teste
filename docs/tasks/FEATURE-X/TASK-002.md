# TASK-002 — Implementar refresh token

## Status
TODO

## Objetivo
Criar o fluxo de renovação de token.

## Contexto
Complementa a autenticação iniciada na TASK-001.

## Dependências
- TASK-001

## Arquivos impactados
- src/controllers/auth.controller.ts
- src/services/token.service.ts
- src/routes/auth.routes.ts

## Critérios de pronto
- endpoint POST /auth/refresh criado
- refresh token validado
- novo access token retornado
- tratamento de erro implementado

## Testes sugeridos
- refresh válido
- refresh inválido
- refresh expirado

## Resultado
- pendente

## Observações
- validar estratégia de expiração com o time
