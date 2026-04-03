# AGENTS.md

<!--
Este arquivo serve como "manual do agente" para o repositório.
Ele explica ao Cursor (e a outros agentes compatíveis com AGENTS.md)
como o projeto deve ser trabalhado.

Objetivo:
- dar contexto persistente para a IA
- definir o fluxo SDD + Scrum
- evitar que a IA implemente features grandes sem especificação
-->

## Objetivo do projeto
Este repositório usa um fluxo de **SDD (Spec-Driven Development)** com lógica de **Scrum** para orientar a execução assistida por IA.

## Fluxo obrigatório
Toda nova funcionalidade deve seguir esta sequência:

1. Ideia / problema
2. PRD (especificação)
3. Plano técnico / arquitetura
4. Quebra em tasks
5. Implementação
6. Testes
7. Validação final

<!--
Esta seção define o processo padrão.
A IA deve seguir esse fluxo antes de sair codando.
-->

## Regras de execução
- Não implementar features grandes a partir de pedidos vagos.
- Sempre começar lendo o PRD em `docs/prd/`.
- Sempre revisar ou gerar um plano técnico em `docs/architecture/`.
- Sempre quebrar o trabalho em tasks dentro de `docs/tasks/<FEATURE>/`.
- Executar **uma task por vez**.
- Antes de iniciar uma task, atualizar o status para `DOING`.
- Ao concluir, atualizar o status para `DONE`.
- Se houver impedimento, usar `BLOCKED` e registrar o motivo.
- Sempre atualizar o `INDEX.md` da feature depois de concluir ou bloquear uma task.

## Comportamento esperado do agente
- Ser objetivo e claro.
- Listar arquivos impactados antes de editar.
- Explicar riscos, dependências e trade-offs quando existirem.
- Sugerir testes sempre que houver mudança relevante.
- Se houver dúvida de requisito, perguntar antes de implementar.

## Mapa do repositório
- `docs/prd/` → especificações / PRDs
- `docs/architecture/` → planos técnicos
- `docs/tasks/` → tasks por feature
- `docs/decisions/` → ADRs / decisões arquiteturais
- `.cursor/rules/` → regras persistentes do Cursor

## Regra de ouro
Se a task não foi atualizada no arquivo correspondente e no `INDEX.md`, ela **não está concluída**.