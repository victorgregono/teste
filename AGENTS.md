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

## Estrutura do projeto

```text
.
├── AGENTS.md                        ← manual do agente: fluxo SDD, regras de execução e mapa do repositório
├── .cursor/
│   ├── hooks.json                   ← registra os hooks do Cursor (afterFileEdit, stop) e seus scripts
│   └── rules/
│       ├── sdd.mdc                  ← rule: garante que o fluxo PRD→arquitetura→tasks→impl seja seguido
│       ├── coding-standards.mdc     ← rule: padrões de código, estilo e boas práticas
│       ├── testing.mdc              ← rule: expectativa mínima de testes e critérios de validação
│       └── task-tracking.mdc        ← rule: obriga atualização de status das tasks nos arquivos
├── docs/
│   ├── prd/
│   │   ├── TEMPLATE-PRD.md          ← template para criar novos PRDs de feature
│   │   └── FEATURE-X-PRD.md         ← exemplo de PRD preenchido (autenticação JWT)
│   ├── architecture/
│   │   ├── TEMPLATE-ARCHITECTURE-PLAN.md   ← template para planos técnicos
│   │   └── FEATURE-X-ARCHITECTURE-PLAN.md  ← exemplo de plano técnico preenchido
│   ├── tasks/
│   │   ├── TEMPLATE-TASK.md         ← template para criar novas tasks individuais
│   │   ├── INDEX.md                 ← índice global com visão consolidada de todas as features
│   │   ├── FEATURE-X/
│   │   │   ├── INDEX.md             ← índice operacional da FEATURE-X (statuses, ordem de execução)
│   │   │   ├── TASK-001.md          ← task: Criar endpoint de login (DONE)
│   │   │   ├── TASK-002.md          ← task: Implementar refresh token (TODO)
│   │   │   └── TASK-003.md          ← task: Criar testes de integração (TODO)
│   │   └── FEATURE-Y/
│   │       ├── INDEX.md             ← índice operacional da FEATURE-Y
│   │       ├── TASK-001.md          ← task: Definir contrato inicial (TODO)
│   │       └── TASK-002.md          ← task: Implementar fluxo principal (TODO)
│   └── decisions/
│       ├── TEMPLATE-ADR.md          ← template para registrar decisões arquiteturais (ADR)
│       └── ADR-001-autenticacao-jwt.md ← ADR: decisão de usar JWT para autenticação
└── specs/
    └── README.md                    ← explica o fluxo SDD e serve de onboarding para novos membros
```

### O que cada parte faz

| Caminho | Função |
|---|---|
| `AGENTS.md` | Manual persistente do agente. Lido automaticamente pelo Cursor e agentes compatíveis. Define fluxo, regras e mapa do projeto. |
| `.cursor/hooks.json` | Configura os hooks do Cursor: `afterFileEdit` (detecta feature e persiste estado) e `stop` (valida tracking de tasks). |
| `.cursor/rules/sdd.mdc` | Rule sempre ativa. Garante que nenhuma feature seja implementada sem PRD, plano técnico e tasks. |
| `.cursor/rules/coding-standards.mdc` | Rule sempre ativa. Define boas práticas de código, simplicidade e coerência. |
| `.cursor/rules/testing.mdc` | Rule sempre ativa. Garante que testes sejam sempre considerados nas entregas. |
| `.cursor/rules/task-tracking.mdc` | Rule sempre ativa. Obriga atualização de status nos arquivos de task e no INDEX.md. |
| `docs/prd/TEMPLATE-PRD.md` | Template padrão para documentar novas features. Cobre contexto, escopo, requisitos e critérios de aceite. |
| `docs/prd/FEATURE-X-PRD.md` | Exemplo real de PRD preenchido para a feature de autenticação JWT. |
| `docs/architecture/TEMPLATE-ARCHITECTURE-PLAN.md` | Template para planos técnicos. Cobre abordagem, arquivos impactados, contratos, riscos e testes. |
| `docs/architecture/FEATURE-X-ARCHITECTURE-PLAN.md` | Exemplo real de plano técnico preenchido para a autenticação JWT. |
| `docs/tasks/TEMPLATE-TASK.md` | Template para tasks individuais. Define status, objetivo, critérios de pronto e resultado. |
| `docs/tasks/INDEX.md` | Índice global consolidado. Visão rápida de quais features têm tasks ativas. |
| `docs/tasks/FEATURE-X/INDEX.md` | Índice operacional da feature. A IA deve ler este arquivo antes de iniciar cada task. |
| `docs/tasks/FEATURE-X/TASK-*.md` | Tasks individuais da feature. Cada task tem status (TODO/DOING/BLOCKED/DONE), critérios e resultado. |
| `docs/decisions/TEMPLATE-ADR.md` | Template para registrar decisões arquiteturais importantes (Architecture Decision Records). |
| `docs/decisions/ADR-001-*.md` | Exemplo de ADR: justificativa para uso de JWT na autenticação. |
| `specs/README.md` | Onboarding do fluxo SDD. Explica o processo para novos membros e reforça o contexto para a IA. |

## Hooks inteligentes (`.cursor/hooks/`)

Os hooks foram evoluídos para detectar automaticamente a feature ativa com esta prioridade:

1. **Payload do hook** — extrai o nome da feature a partir do caminho do arquivo editado
   (ex.: `docs/tasks/FEATURE-X/TASK-002.md`, `docs/prd/FEATURE-X-PRD.md`)
2. **Task em DOING** — procura tasks com status `DOING` em `docs/tasks/<FEATURE>/TASK-*.md`
3. **Feature mais recente** — pega a feature com o arquivo mais recentemente alterado em `docs/tasks/`

A feature detectada é persistida em `.cursor/state/active-feature.txt` para ser reutilizada pelo hook `stop`, sem depender da memória da conversa.

Arquivos gerados em runtime (não versionados):

```text
.cursor/state/active-feature.txt   ← última feature ativa detectada
.cursor/logs/post-edit.log         ← log de cada afterFileEdit
.cursor/logs/task-tracking.log     ← log de cada stop
```

## Exemplos de uso

### Prompt 1 — Criar uma nova feature

**Cenário:** Você quer criar a feature de **upload de arquivos**.

```
Leia @docs/prd/TEMPLATE-PRD.md e crie um novo PRD para a feature upload-de-arquivos.
Depois gere um plano técnico com base no template em @docs/architecture/TEMPLATE-ARCHITECTURE-PLAN.md.
Não implemente ainda.
```

**O que acontece:**
- Gera `docs/prd/UPLOAD-DE-ARQUIVOS-PRD.md` com contexto, escopo, requisitos e critérios de aceite.
- Gera `docs/architecture/UPLOAD-DE-ARQUIVOS-ARCHITECTURE-PLAN.md` com abordagem técnica, arquivos impactados e riscos.
- Nenhum código é alterado.

---

### Prompt 2 — Quebrar em tasks

**Cenário:** PRD e plano técnico prontos, hora de criar as tasks.

```
Leia:
- @docs/prd/UPLOAD-DE-ARQUIVOS-PRD.md
- @docs/architecture/UPLOAD-DE-ARQUIVOS-ARCHITECTURE-PLAN.md
- @docs/tasks/TEMPLATE-TASK.md

Agora crie as tasks da feature em @docs/tasks/UPLOAD-DE-ARQUIVOS/
e gere também o @docs/tasks/UPLOAD-DE-ARQUIVOS/INDEX.md.
```

**O que acontece:**
- Cria tasks individuais: `TASK-001.md`, `TASK-002.md`, etc., todas com status `TODO`.
- Cria o `INDEX.md` da feature com visão consolidada dos statuses.

---

### Prompt 3 — Executar uma task

**Cenário:** Você quer implementar a TASK-002.

```
Leia @docs/tasks/UPLOAD-DE-ARQUIVOS/INDEX.md e @docs/tasks/UPLOAD-DE-ARQUIVOS/TASK-002.md.

Se a task estiver em TODO:
1. atualize para DOING
2. me diga quais arquivos serão alterados
3. implemente apenas essa task
4. ao concluir, atualize a task para DONE
5. atualize também o INDEX.md
6. resuma o que foi feito
```

**O que acontece:**
1. Status da TASK-002 muda para `DOING`.
2. Lista os arquivos que serão modificados.
3. Implementa **somente** aquela task.
4. Atualiza o status para `DONE` com resultado registrado.
5. Atualiza o `INDEX.md` da feature.

---

### Prompt bônus — Retomar o trabalho

**Cenário:** Voltou ao projeto depois de um tempo e quer saber por onde continuar.

```
Leia @docs/tasks/UPLOAD-DE-ARQUIVOS/INDEX.md e me diga qual é a próxima task a executar.
```

O agente encontra a próxima `TODO`, carrega o contexto completo e já está pronto para executar — sem precisar reexplicar nada.

---

## Regra de ouro
Se a task não foi atualizada no arquivo correspondente e no `INDEX.md`, ela **não está concluída**.

---

<img width="1024" height="1050" alt="Gemini_Generated_Image_ey95kjey95kjey95" src="https://github.com/user-attachments/assets/33cc8deb-20c7-48f1-9be6-e166ea60b5b9" />
<img width="1024" height="1050" alt="Gemini_Generated_Image_ey95kjey95kjey95" src="https://github.com/user-attachments/assets/33cc8deb-20c7-48f1-9be6-e166ea60b5b9" />
<img width="1411" height="736" alt="Gemini_Generated_Image_u31ljdu31ljdu31l" src="https://github.com/user-attachments/assets/65fbdcb1-160d-40b8-8a79-f80a2b77468e" />
<img width="1411" height="736" alt="Gemini_Generated_Image_u31ljdu31ljdu31l" src="https://github.com/user-attachments/assets/65fbdcb1-160d-40b8-8a79-f80a2b77468e" />

