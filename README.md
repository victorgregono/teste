# SDD Template Repository

Este repositório implementa um fluxo de **SDD (Spec-Driven Development)** com lógica de **Scrum** para orientar o desenvolvimento assistido por IA.

## O que é SDD?

Spec-Driven Development é uma abordagem onde **nenhuma feature começa pelo código**. Toda implementação parte de uma especificação clara (PRD), passa por um plano técnico, é quebrada em tasks e só então é implementada.

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
│   ├── hooks/                       ← scripts executados automaticamente pelos hooks do Cursor
│   │   ├── detect-active-feature.sh ← detecta a feature ativa com base no arquivo editado ou task em DOING
│   │   ├── post-edit-check.sh       ← executado após cada edição: persiste estado e loga a feature ativa
│   │   └── check-task-tracking.sh   ← executado no stop: valida se todas as tasks foram atualizadas
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
| `.cursor/hooks.json` | Configura os hooks do Cursor: `afterFileEdit` (chama `post-edit-check.sh`) e `stop` (chama `check-task-tracking.sh`). |
| `.cursor/hooks/detect-active-feature.sh` | Detecta a feature ativa com 3 níveis de prioridade: payload do hook → task em DOING → feature mais recente. Aplica whitelist `[A-Za-z0-9_-]` em todos os candidatos. |
| `.cursor/hooks/post-edit-check.sh` | Executado após cada `afterFileEdit`. Chama `detect-active-feature.sh`, valida o resultado e persiste em `active-feature.txt` com `flock -x` (lock exclusivo). |
| `.cursor/hooks/check-task-tracking.sh` | Executado no `stop`. Lê `active-feature.txt` com `flock -s` (lock compartilhado), valida o valor e verifica tasks em DOING sem atualização. |
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

---

## O que são os Hooks e por que existem neste projeto?

> **Se você nunca ouviu falar de hooks de editor, leia esta seção antes de continuar.**

### O problema que eles resolvem

Quando você trabalha com uma IA (como o Cursor) para implementar features, existe um risco real: **a IA pode editar arquivos sem que o time saiba qual feature está sendo trabalhada**, ou pode encerrar a sessão sem ter atualizado o status das tasks (`TODO → DOING → DONE`).

Com o tempo, isso gera:
- Tasks desatualizadas (status antigo no arquivo, feature já implementada na prática)
- Falta de rastreabilidade ("quem fez isso? quando? em qual feature?")
- Conflitos em sessões paralelas (duas IAs ou dois devs editando ao mesmo tempo)

### O que são hooks?

**Hooks são scripts shell que o Cursor executa automaticamente** em momentos específicos do ciclo de edição — sem que você precise chamar nada manualmente.

Neste projeto, dois eventos disparam hooks:

| Evento | Quando ocorre | Script executado |
|---|---|---|
| `afterFileEdit` | Toda vez que qualquer arquivo é salvo/editado no Cursor | `post-edit-check.sh` |
| `stop` | Quando a sessão de agente é encerrada | `check-task-tracking.sh` |

### O que cada hook faz neste projeto especificamente

#### Ao editar um arquivo (`afterFileEdit`)
1. O Cursor detecta o arquivo que foi editado
2. Chama `post-edit-check.sh`
3. Esse script chama `detect-active-feature.sh` para descobrir **qual feature está sendo trabalhada** (baseado no caminho do arquivo, ou em qual task está em `DOING`)
4. O nome da feature é validado e salvo em `.cursor/state/active-feature.txt`
5. Tudo é registrado em `.cursor/logs/post-edit.log`

**Por que isso importa?** Porque agora sempre há um registro de qual feature está ativa — útil tanto para a IA quanto para o time.

#### Ao encerrar a sessão (`stop`)
1. O Cursor chama `check-task-tracking.sh`
2. Esse script lê a feature ativa salva anteriormente
3. Verifica se alguma task ficou presa no status `DOING` sem ser atualizada para `DONE` ou `BLOCKED`
4. Alerta sobre inconsistências de tracking
5. Registra tudo em `.cursor/logs/task-tracking.log`

**Por que isso importa?** Porque impede que o time termine o dia com tasks "fantasma" em `DOING` — tasks que na prática foram concluídas mas nunca tiveram o status atualizado.

### Resumo visual

```
Você edita um arquivo
        ↓
  [afterFileEdit]
        ↓
 post-edit-check.sh
        ↓
 Detecta a feature ativa → salva em active-feature.txt

Você encerra a sessão
        ↓
     [stop]
        ↓
check-task-tracking.sh
        ↓
 Lê a feature ativa → verifica tasks em DOING → alerta se necessário
```

### Preciso configurar algo?

Não. Os hooks já estão configurados em `.cursor/hooks.json`. Se você usa o **Cursor**, eles rodam automaticamente. Se usa outro editor, os scripts podem ser chamados manualmente ou integrados a outro sistema de hooks.

---

## Hooks inteligentes (`.cursor/hooks/`)

Os hooks são scripts shell executados automaticamente pelo Cursor em momentos-chave do ciclo de edição.

### Scripts disponíveis

#### `detect-active-feature.sh`
Detecta a feature ativa com a seguinte ordem de prioridade:

1. **Payload do hook** — extrai o nome da feature a partir do caminho do arquivo editado
2. **Task em DOING** — procura tasks com status `DOING` em `docs/tasks/<FEATURE>/TASK-*.md`
3. **Feature mais recente** — pega a feature com o arquivo mais recentemente alterado em `docs/tasks/`

Todos os candidatos a nome de feature passam pela função `sanitize_feature`, que aplica uma **whitelist** de caracteres `[A-Za-z0-9_-]`. Nomes que não satisfazem essa restrição são descartados silenciosamente.

#### `post-edit-check.sh`
Executado pelo hook `afterFileEdit`. Responsável por:
- Chamar `detect-active-feature.sh` para identificar a feature ativa
- Validar o nome retornado com a função `is_valid_feature` (whitelist `[A-Za-z0-9_-]`) antes de qualquer escrita
- Persistir o resultado em `.cursor/state/active-feature.txt` usando **`flock -x`** (lock exclusivo com timeout de 5 s) para garantir atomicidade em sessões paralelas
- Registrar a execução em `.cursor/logs/post-edit.log`

#### `check-task-tracking.sh`
Executado no hook `stop`. Responsável por:
- Ler `.cursor/state/active-feature.txt` usando **`flock -s`** (lock compartilhado) para evitar leitura parcial
- Validar o valor lido com `is_valid_feature` antes de usá-lo
- Verificar se existem tasks com status `DOING` que não foram atualizadas
- Alertar quando o tracking de tasks está inconsistente
- Registrar o resultado em `.cursor/logs/task-tracking.log`

### Segurança e escalabilidade

| Garantia | Implementação |
|---|---|
| Sanitização de inputs | Todos os nomes de feature passam por whitelist `^[A-Za-z0-9_-]+$` antes de serem usados em paths ou escritos em disco |
| Prevenção de path traversal | Nomes que contenham `/`, `..`, espaços ou caracteres especiais são rejeitados na validação |
| Acesso concorrente (escrita) | `post-edit-check.sh` usa `flock -x -w 5` (timeout de 5 s) no arquivo de lock antes de sobrescrever `active-feature.txt` |
| Acesso concorrente (leitura) | `check-task-tracking.sh` usa `flock -s -w 5` (timeout de 5 s) para ler `active-feature.txt` sem race condition |

### Arquivos gerados em runtime (não versionados)

```text
.cursor/state/active-feature.txt      ← última feature ativa detectada
.cursor/state/active-feature.txt.lock ← arquivo de lock gerado automaticamente pelo flock (não versionar)
.cursor/logs/post-edit.log            ← log de cada afterFileEdit
.cursor/logs/task-tracking.log        ← log de cada stop
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