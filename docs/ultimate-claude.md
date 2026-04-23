# Ultimate Claude Code Setup
> Guia completo do que foi instalado, como usar e como replicar em outro PC.
> Arquivo criado em: 2026-04-16

---

## O QUE FOI INSTALADO

### Ferramentas Globais (npm)

| Ferramenta | Versao | Comando | Para que serve |
|---|---|---|---|
| **repomix** | latest | `npx repomix` | Empacota TODA a codebase num arquivo otimizado para IA. Economiza tokens enormemente. |
| **ccusage** | latest | `ccusage` | Dashboard de uso: tokens consumidos, custo, sessoes. |
| **task-master-ai** | latest | `task-master` | Sistema de tarefas integrado ao Claude. Gerencia PRDs, tasks, dependencias. |

### GSD - Get Shit Done (MAIS IMPORTANTE)
- **Repo:** https://github.com/gsd-build/get-shit-done
- **Versao:** v1.36.0 — 53k stars
- **Instalado em:** `~/.claude/` (global)
- **O que faz:** Sistema de workflow spec-driven que previne "context rot". Executa tarefas em ondas paralelas. Cada fase tem 200k tokens frescos.

**Hooks instalados automaticamente:**
- Context window monitor (avisa quando contexto enche)
- Prompt injection guard
- Read-before-edit guard
- Workflow guard

**Comandos principais:**
```
/gsd-new-project      -> Inicializa projeto completo com requisitos e roadmap
/gsd-plan-phase N     -> Pesquisa e cria plano para fase N
/gsd-execute-phase N  -> Executa plano em ondas paralelas
/gsd-verify-work      -> User acceptance testing
/gsd-ship N           -> Cria PR do trabalho verificado
/gsd-quick            -> Tarefa ad-hoc rapida sem overhead de planejamento
/gsd-next             -> Auto-detecta e avanca para proximo passo
```

### SuperClaude Framework
- **Repo:** https://github.com/SuperClaude-Org/SuperClaude_Framework
- **Versao:** 4.3.0
- **Instalado em:** `~/.claude/commands/sc/` (31 comandos) + `~/.claude/agents/` (20 agentes)

**Comandos SuperClaude (`/sc:`):**
```
/sc:implement    -> Implementacao de features
/sc:research     -> Pesquisa profunda sobre qualquer topico
/sc:analyze      -> Analise de codigo/arquitetura
/sc:test         -> Geracao de testes
/sc:improve      -> Melhoria de codigo existente
/sc:design       -> Design de sistemas
/sc:build        -> Build e compilacao
/sc:troubleshoot -> Debug e diagnostico
/sc:document     -> Geracao de documentacao
/sc:brainstorm   -> Brainstorming estruturado
/sc:workflow     -> Workflows customizados
/sc:spawn        -> Spawna subagentes especializados
```

**Agentes SuperClaude (`@`):**
```
@backend-architect      -> Arquitetura de backend
@frontend-architect     -> Arquitetura de frontend
@security-engineer      -> Auditoria de seguranca
@performance-engineer   -> Otimizacao de performance
@quality-engineer       -> QA e testes
@deep-research-agent    -> Pesquisa aprofundada
@system-architect       -> Arquitetura de sistemas
@python-expert          -> Especialista Python
@devops-architect       -> CI/CD, infra, DevOps
@technical-writer       -> Documentacao tecnica
@refactoring-expert     -> Refatoracao de codigo
@root-cause-analyst     -> Analise de causa raiz de bugs
```

---

## FRONTEND DESIGN PLUGIN

- **Pagina:** https://claude.com/plugins/frontend-design
- **Instalado em:** `~/.claude/` (escopo user)
- **O que faz:** Transforma o Claude num designer de UI de alto nivel. Ativa automaticamente em qualquer pedido de interface frontend. Evita estetica generica ("AI slop") e forca escolhas visuais distintas.

**Como usar:**
```
# Apenas descreva o que quer — o plugin ativa sozinho
"Crie uma landing page para um SaaS de monitoramento"
"Dashboard de analytics com tema escuro"
"Componente de card com animacoes"
```

**Dica:** Use Shift+Tab (modo planejamento) antes de pedir uma UI para revisar a direcao estetica antes de codificar.

**O que ele evita:**
- Fontes: Inter, Roboto, Arial
- Cores: gradiente roxo em fundo branco
- Layouts previsíveis e sem carater

**O que ele usa:**
- Tipografia distinta e contextual
- CSS variables para coerencia de cor
- Animacoes de alto impacto
- Composicao espacial inesperada (assimetria, sobreposicao, grade quebrada)

**Para instalar manualmente:**
```bash
claude plugins install frontend-design
```

---

## MCP SERVERS CONFIGURADOS

Configurados em `~/.claude/settings.json`:

### 1. Sequential Thinking
- **Para que serve:** Quebra tarefas complexas em passos logicos. Ideal para arquitetura e design.
- **Comando:** `npx -y @modelcontextprotocol/server-sequential-thinking`

### 2. Context7
- **Para que serve:** Busca documentacao atualizada direto dos repos oficiais. Zero docs desatualizadas.
- **Comando:** `npx -y @upstash/context7-mcp`
- **Como usar:** Adicione `use context7` no prompt. Ex: *"Como usar useEffect? use context7"*

### 3. Filesystem
- **Para que serve:** Claude le/escreve arquivos com fronteiras configuradas.
- **Servidor:** `@modelcontextprotocol/server-filesystem`

---

## ECONOMIA DE TOKENS - TECNICAS

### 1. Repomix (MAIOR IMPACTO)
```bash
# Empacotar projeto inteiro para contexto
npx repomix

# Incluir arquivos especificos
npx repomix --include "src/**/*.ts,**/*.md"

# Ignorar node_modules e build
npx repomix --ignore "node_modules,dist,build"

# Saida comprimida (ainda menor)
npx repomix --compress
```
O arquivo `repomix-output.xml` resultante e otimizado para IA e usa menos tokens que arquivos separados.

### 2. CLAUDE.md Otimizado
Tenha um `CLAUDE.md` na raiz de cada projeto com:
- Stack tecnica (evita Claude perguntar)
- Comandos de build/test/lint
- Convencoes de codigo
- O que NAO fazer

### 3. GSD Wave Execution
O GSD divide trabalho em ondas: cada wave tem contexto fresco de 200k tokens.
Sem acumulacao de "lixo" no contexto ao longo da sessao.

### 4. Context7 MCP
Claude nao precisa gerar docs de memoria. Busca diretamente da fonte.
Reduz alucinacoes e tokens de "contexto defensivo".

---

## VELOCIDADE DE RESPOSTA

### Dicas para respostas mais rapidas:

1. **Use `/gsd-quick` para tarefas simples** — sem overhead de planejamento
2. **Seja especifico no prompt** — menos inferencia = mais rapido
3. **Use agentes paralelos** (`/sc:spawn`) — varias tarefas simultaneas
4. **Limite o contexto** — nao jogue arquivos irrelevantes no chat
5. **Use modelos menores quando possivel** — Haiku para tarefas simples

### Modelo recomendado por tarefa:
| Tarefa | Modelo |
|---|---|
| Planejamento/Arquitetura | Opus 4.6 |
| Implementacao | Sonnet 4.6 (padrao) |
| Verificacao/Lint simples | Haiku 4.5 |

---

## WORKFLOW RECOMENDADO (NOVO PROJETO)

```
1. Criar pasta do projeto
2. Abrir Claude Code na pasta
3. /gsd-new-project           -> Gera PROJECT.md, REQUIREMENTS.md, ROADMAP.md
4. /gsd-discuss-phase 1       -> Decisoes de implementacao
5. /gsd-plan-phase 1          -> Plano detalhado
6. /gsd-execute-phase 1       -> Execucao em paralelo
7. /gsd-verify-work 1         -> Verificacao
8. /gsd-ship 1                -> PR
9. Repetir para proximas fases
```

---

## OUTROS REPOS IMPORTANTES (Instalar conforme necessidade)

### Orquestradores Multi-Agente
| Repo | Stars | O que faz |
|---|---|---|
| [claude-squad](https://github.com/smtg-ai/claude-squad) | alto | Terminal com multiplos agentes em paralelo |
| [claude-swarm](https://github.com/parruda/claude-swarm) | medio | Swarm de agentes Claude Code |
| [claude-code-flow](https://github.com/ruvnet/claude-code-flow) | medio | Orquestracao code-first |
| [Auto-Claude](https://github.com/AndyMik90/Auto-Claude) | medio | Framework multi-agente com UI kanban |

### Monitoramento
| Repo | O que faz | Instalar |
|---|---|---|
| [ccxray](https://github.com/lis186/ccxray) | Proxy HTTP com dashboard de tokens em tempo real | `pip install ccxray` |
| [claude-pace](https://github.com/Astro-Han/claude-pace) | Statusline com burn rate de rate limit | npm |
| [cc-usage](https://github.com/ryoppippi/ccusage) | CLI de analytics | `npm i -g ccusage` (JA INSTALADO) |

### Hooks Uteis
| Repo | O que faz |
|---|---|
| [Dippy](https://github.com/ldayton/Dippy) | Auto-aprova comandos bash seguros via AST |
| [TDD Guard](https://github.com/nizos/tdd-guard) | Forca principios TDD |
| [parry](https://github.com/vaporif/parry) | Scanner de prompt injection |
| [CC Notify](https://github.com/dazuiba/CCNotify) | Notificacoes desktop quando Claude termina |

### Skills Adicionais
| Repo | O que faz |
|---|---|
| [Trail of Bits Security](https://github.com/trailofbits/skills) | Auditoria de seguranca com CodeQL/Semgrep |
| [Fullstack Dev Skills](https://github.com/jeffallan/claude-skills) | 65 skills para fullstack |
| [Superpowers](https://github.com/obra/superpowers) | Competencias core do ciclo de software |

---

## CONFIGURACAO MCP COMPLETA

MCPs NO ficam em `settings.json`. Ficam em `~/.claude.json` e sao gerenciados via CLI:

```bash
# Adicionar MCP (sintaxe correta)
claude mcp add nome-do-servidor -- npx -y "pacote-npm"

# Listar MCPs configurados
claude mcp list

# Remover MCP
claude mcp remove nome-do-servidor
```

### MCPs Recomendados Extras (instalar quando precisar)
```bash
# GitHub - acesso a repos, issues, PRs
claude mcp add github -- npx -y @modelcontextprotocol/server-github

# Postgres - queries em linguagem natural
claude mcp add postgres -- npx -y @modelcontextprotocol/server-postgres

# Puppeteer - automacao de browser
claude mcp add puppeteer -- npx -y @modelcontextprotocol/server-puppeteer

# Notion - acesso ao workspace
claude mcp add notion -- npx -y @notionhq/notion-mcp-server
```

---

## ESTRUTURA DO ~/.claude APOS SETUP

```
~/.claude/
├── settings.json          # MCP servers + hooks + config
├── CLAUDE.md              # Instrucoes globais para o Claude
├── commands/
│   └── sc/                # 31 comandos SuperClaude
├── agents/                # 20 agentes SuperClaude + agentes GSD
├── skills/                # 73 skills GSD
├── hooks/                 # Hooks GSD (context monitor, injection guard, etc.)
└── memory/                # Auto-memoria persistente
```

---

## REPLICAR EM OUTRO PC

Clone o repo privado e execute:

```bash
# Windows (PowerShell)
git clone https://github.com/FalvesDev/ultimate-claude-setup.git
cd ultimate-claude-setup
./setup.ps1

# Linux/Mac
git clone https://github.com/FalvesDev/ultimate-claude-setup.git
cd ultimate-claude-setup
chmod +x setup.sh && ./setup.sh
```

O script instala tudo automaticamente e configura o `~/.claude/settings.json`.

---

## STATUS DAS INSTALACOES (2026-04-16)

| Ferramenta | Status | Versao |
|---|---|---|
| GSD | INSTALADO | v1.36.0 |
| SuperClaude | INSTALADO | v4.3.0 (31 cmds + 20 agents) |
| repomix | INSTALADO | latest |
| ccusage | INSTALADO | latest |
| task-master-ai | INSTALADO | latest |
| MCP Sequential Thinking | CONFIGURADO | latest |
| MCP Context7 | CONFIGURADO | latest |
| MCP Filesystem | CONFIGURADO | latest |
| Frontend Design Plugin | INSTALADO | latest |

---

*Para atualizar o GSD: `npx get-shit-done-cc@latest --claude --global`*
*Para atualizar SuperClaude: `pip install --upgrade superclaude && superclaude install`*
