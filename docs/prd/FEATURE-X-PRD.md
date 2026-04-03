# PRD — Login com autenticação JWT

<!--
Exemplo de PRD preenchido para servir como referência real.
-->

## 1. Contexto
Hoje o sistema não possui um fluxo de autenticação padronizado para acesso seguro às rotas protegidas.

## 2. Objetivo
Permitir login com email e senha, retornando access token e refresh token.

## 3. Problema atual
Atualmente, o acesso a funcionalidades protegidas depende de mecanismos inconsistentes entre módulos.

## 4. Escopo

### Inclui
- login com email e senha
- geração de access token
- geração de refresh token
- middleware de autenticação

### Não inclui
- login social
- MFA

## 5. Usuários / atores impactados
- usuário autenticado
- backend
- frontend

## 6. Requisitos funcionais
- [RF01] O usuário deve conseguir autenticar com email e senha.
- [RF02] O backend deve retornar access token e refresh token.
- [RF03] O sistema deve proteger rotas autenticadas.

## 7. Requisitos não funcionais
- logs sem dados sensíveis
- boa tratativa de erro
- testes mínimos automatizados

## 8. Regras de negócio
- credenciais inválidas devem retornar 401
- token expirado deve exigir renovação

## 9. Critérios de aceite
- [CA01] Login válido retorna 200 com tokens.
- [CA02] Login inválido retorna 401.
- [CA03] Rotas protegidas exigem token válido.

## 10. Dependências
- serviço de usuários
- biblioteca JWT

## 11. Riscos / pontos de atenção
- expiração incorreta de token
- vazamento de dados em logs

## 12. Dúvidas em aberto
- duração final do refresh token
- estratégia de invalidação

## 13. Métricas de sucesso
- login funcionando em ambiente de homologação
- testes principais cobrindo fluxo básico

## 14. Referências
- ticket AUTH-001
- documentação de segurança
