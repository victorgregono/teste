# ADR — Estratégia de autenticação com JWT

## Status
Aprovado

## Contexto
O sistema precisava de uma estratégia de autenticação escalável e compatível com serviços distribuídos.

## Decisão
Adotar JWT para access token e refresh token para renovação de sessão.

## Alternativas consideradas
- sessão em memória
- sessão em banco
- autenticação externa terceirizada

## Consequências

### Positivas
- validação distribuída simplificada
- desacoplamento de sessão de servidor único

### Negativas
- maior cuidado com expiração e invalidação
- necessidade de política clara de refresh token

## Impactos
- backend
- segurança
- frontend
- testes

## Referências
- docs/prd/FEATURE-X-PRD.md
- docs/architecture/FEATURE-X-ARCHITECTURE-PLAN.md
