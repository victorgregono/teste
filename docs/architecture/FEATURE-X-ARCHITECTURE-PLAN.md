# Plano Técnico — Login com autenticação JWT

<!--
Exemplo preenchido para servir como base para futuras features.
-->

## 1. Objetivo técnico
Implementar autenticação JWT com login, refresh token e middleware de proteção de rotas.

## 2. Resumo da solução
Será criado um fluxo de autenticação com endpoint de login, endpoint de refresh e middleware para validação de token.

## 3. Arquivos / módulos impactados
- src/controllers/auth.controller.ts
- src/services/auth.service.ts
- src/services/token.service.ts
- src/middleware/auth.middleware.ts
- src/routes/auth.routes.ts

## 4. Arquitetura atual
O sistema possui cadastro de usuários, mas ainda não possui um módulo central de autenticação.

## 5. Mudanças propostas

### Backend
- criar controller de auth
- criar service para geração/validação de token

### Frontend
- integrar fluxo de login com armazenamento do token

### Banco / persistência
- avaliar necessidade de persistência de refresh token

### Integrações
- integração com serviço atual de usuários

## 6. Contratos / interfaces
- POST /auth/login
- POST /auth/refresh
- Authorization: Bearer <token>

## 7. Estratégia de implementação
1. Criar tipos e contratos
2. Implementar login
3. Implementar refresh
4. Criar middleware
5. Criar testes

## 8. Estratégia de rollback
Desativar rotas novas e reverter módulo de autenticação.

## 9. Impactos e riscos
- falhas na expiração do token
- mudanças no contrato com frontend

## 10. Trade-offs
- usar JWT simplifica validação distribuída
- exige cuidado com expiração e renovação

## 11. Observabilidade
- logar falhas de autenticação sem dados sensíveis
- acompanhar taxa de erro em login

## 12. Segurança
- validar credenciais
- não expor token em logs
- validar payloads de entrada

## 13. Estratégia de testes

### Unitários
- geração de token
- validação de token

### Integração
- login válido
- login inválido
- refresh válido/inválido

### E2E
- acesso a rota protegida com token válido

## 14. Critérios técnicos de pronto
- endpoints funcionando
- middleware ativo
- testes principais cobrindo fluxo básico
- documentação atualizada
