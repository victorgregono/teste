# Existing content before modifications.

---

## O que são os Hooks e por que existem neste projeto?

> **Se você nunca ouviu falar de hooks de editor, leia esta seção antes de continuar.**

### O problema que eles resolvem

Quando você trabalha com uma IA (como o Cursor) para implementar features, existe um risco real: **a IA pode editar arquivos sem que o time saiba qual feature está sendo trabalhada**, ou pode encerrar uma sessão sem ter atualizado o status das tasks (`TODO → DOING → DONE`).

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