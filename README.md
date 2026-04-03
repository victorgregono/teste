# SDD Template Repository

Este repositório implementa um fluxo de **SDD (Spec-Driven Development)** com lógica de **Scrum** para orientar o desenvolvimento assistido por IA.

## O que é SDD?

Spec-Driven Development é uma abordagem onde **nenhuma feature começa pelo código**. Toda implementação parte de uma especificação clara (PRD), passa por um plano técnico, é quebrada em tasks rastreáveis e só então é executada — uma task por vez.

Isso garante:
- Mais contexto para a IA e para o time
- Menos retrabalho
- Melhor qualidade técnica
- Rastreabilidade completa das decisões

---

## Fluxo de desenvolvimento

```
Ideia → PRD → Plano técnico → Tasks → Implementação → Testes → Validação
```

1. **Ideia / problema** — identifique o que precisa ser feito
2. **PRD** — documente contexto, escopo, requisitos e critérios de aceite em `docs/prd/`
3. **Plano técnico** — defina abordagem, arquivos impactados e riscos em `docs/architecture/`
4. **Quebra em tasks** — crie tasks individuais rastreáveis em `docs/tasks/<FEATURE>/`
5. **Implementação** — execute uma task por vez, atualizando os status
6. **Testes** — valide cada entrega
7. **Validação final** — confirme que todos os critérios de aceite foram atendidos

---

## Estrutura do projeto

```text
.
├── AGENTS.md                        ← manual do agente: fluxo SDD, regras de execução
├── README.md                        ← este arquivo: onboarding e documentação para humanos
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
| `docs/prd/TEMPLATE-PRD.md` | Template padrão para documentar novas features. Cobre contexto, escopo, requisitos e crit��rios de aceite. |
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

---

## Hooks inteligentes (`.cursor/hooks/`)

Os hooks detectam automaticamente a feature ativa com esta prioridade:

1. **Payload do hook** — extrai o nome da feature a partir do caminho do arquivo editado
2. **Task em DOING** — procura tasks com status `DOING` em `docs/tasks/<FEATURE>/TASK-*.md`
3. **Feature mais recente** — pega a feature com o arquivo mais recentemente alterado em `docs/tasks/`

Arquivos gerados em runtime (não versionados):

```text
.cursor/state/active-feature.txt   ← última feature ativa detectada
.cursor/logs/post-edit.log         ← log de cada afterFileEdit
.cursor/logs/task-tracking.log     ← log de cada stop
```

---

## Exemplos de uso

### Prompt 1 — Criar uma nova feature

```
Leia @docs/prd/TEMPLATE-PRD.md e crie um novo PRD para a feature upload-de-arquivos.
Depois gere um plano técnico com base no template em @docs/architecture/TEMPLATE-ARCHITECTURE-PLAN.md.
Não implemente ainda.
```

### Prompt 2 — Quebrar em tasks

```
Leia:
- @docs/prd/UPLOAD-DE-ARQUIVOS-PRD.md
- @docs/architecture/UPLOAD-DE-ARQUIVOS-ARCHITECTURE-PLAN.md
- @docs/tasks/TEMPLATE-TASK.md

Agora crie as tasks da feature em @docs/tasks/UPLOAD-DE-ARQUIVOS/
e gere também o @docs/tasks/UPLOAD-DE-ARQUIVOS/INDEX.md.
```

### Prompt 3 — Executar uma task

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

### Prompt bônus — Retomar o trabalho

```
Leia @docs/tasks/UPLOAD-DE-ARQUIVOS/INDEX.md e me diga qual é a próxima task a executar.
```

---

<img width="1024" height="1050" alt="Gemini_Generated_Image_ey95kjey95kjey95" src="https://github.com/user-attachments/assets/a2abae4e-0802-4164-84d6-b058484664ba" />
<img width="1411" height="736" alt="Gemini_Generated_Image_u31ljdu31ljdu31l" src="https://github.com/user-attachments/assets/6e0cc160-b2c5-42e4-852b-983e4d550b89" />

