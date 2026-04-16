# Ultimate Claude Code Setup

> Setup completo para transformar o Claude Code num ambiente de desenvolvimento de elite.
> Workflow spec-driven + agentes especializados + multi-agente paralelo + MCP servers.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Testado em](https://img.shields.io/badge/testado%20em-Windows%2010%2F11%20%7C%20Ubuntu%2022%2B%20%7C%20macOS%2013%2B-blue)]()
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-blueviolet)](https://claude.ai/code)

**Idioma:** Portugues (PT-BR) | [English version coming soon]

---

## O que e este projeto?

Um script de instalacao e guia completo que configura o Claude Code com as melhores ferramentas da comunidade open source em um unico comando.

**Instalado e configurado automaticamente:**

| Ferramenta | O que faz |
|---|---|
| [GSD](https://github.com/gsd-build/get-shit-done) | Workflow spec-driven, previne context rot, execucao paralela |
| [SuperClaude](https://github.com/SuperClaude-Org/SuperClaude_Framework) | 31 comandos `/sc:` + 20 agentes especializados |
| [repomix](https://github.com/yamadashy/repomix) | Empacota codebase para IA, economiza tokens |
| [ccusage](https://github.com/ryoppippi/ccusage) | Dashboard de consumo de tokens |
| [task-master](https://github.com/eyaltoledano/claude-task-master) | Gerenciamento de tarefas com IA |
| [claude-squad](https://github.com/smtg-ai/claude-squad) | Multi-agente paralelo (requer tmux/WSL2) |
| MCP: sequential-thinking | Raciocinio em passos logicos |
| MCP: context7 | Documentacao atualizada em tempo real |
| MCP: filesystem | Acesso seguro a arquivos locais |

---

## Instalacao rapida

**Pre-requisitos:** Node.js 18+, Python 3.10+, git, [Claude Code CLI](https://claude.ai/code)

```bash
git clone https://github.com/FalvesDev/ultimate-claude-setup.git
cd ultimate-claude-setup
```

**Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy Bypass -File setup.ps1
```

**Linux / macOS / WSL2:**
```bash
chmod +x setup.sh && ./setup.sh
```

Reinicie o Claude Code apos a instalacao.

---

## Como usar cada ferramenta

### GSD — Workflow para projetos

O GSD divide o trabalho em fases com contexto fresco a cada execucao, evitando degradacao de qualidade em projetos longos.

```
# Fluxo padrao para novo projeto:

1. /gsd-new-project        → cria PROJECT.md, REQUIREMENTS.md, ROADMAP.md
2. /gsd-discuss-phase 1    → captura decisoes antes de planejar
3. /gsd-plan-phase 1       → pesquisa + plano detalhado
4. /gsd-execute-phase 1    → executa em ondas paralelas
5. /gsd-verify-work 1      → verifica contra os objetivos
6. /gsd-ship 1             → cria PR

# Para tarefas rapidas sem planejamento:
/gsd-quick "adicionar validacao no formulario de login"
```

**Todos os comandos:**

| Comando | Para que serve |
|---|---|
| `/gsd-new-project` | Inicializa projeto com requisitos e roadmap |
| `/gsd-quick [tarefa]` | Tarefa rapida sem overhead |
| `/gsd-discuss-phase N` | Captura decisoes da fase N |
| `/gsd-plan-phase N` | Pesquisa + plano da fase N |
| `/gsd-execute-phase N` | Executa fase N em paralelo |
| `/gsd-verify-work N` | Verifica resultado da fase N |
| `/gsd-ship N` | Cria PR da fase N |
| `/gsd-next` | Avanca automaticamente |
| `/gsd-complete-milestone` | Arquiva milestone + tag |

---

### SuperClaude — Comandos e Agentes

**Comandos `/sc:`** — use dentro do Claude Code:

```bash
/sc:implement "adicionar autenticacao JWT"
/sc:research  "melhores praticas para rate limiting em APIs"
/sc:analyze   src/auth/middleware.ts
/sc:test      src/services/userService.ts
/sc:improve   "refatorar para async/await"
/sc:design    "arquitetura de microservicos para e-commerce"
/sc:troubleshoot "erro 500 ao fazer login com Google OAuth"
/sc:document  src/api/
/sc:build
/sc:spawn     "crie agentes para backend, frontend e testes"
```

**Agentes `@`** — especialistas em sub-tarefas:

```bash
@backend-architect    "projete a camada de dados para notificacoes"
@frontend-architect   "estruture dashboard com React Query e Zustand"
@security-engineer    "audite este endpoint de upload de arquivos"
@performance-engineer "otimize estas queries N+1"
@quality-engineer     "crie suite de testes para o modulo de pagamento"
@devops-architect     "configure CI/CD com GitHub Actions"
@python-expert        "otimize este script de processamento de dados"
@refactoring-expert   "refatore para seguir principios SOLID"
@root-cause-analyst   "por que esta funcao falha apenas em producao?"
@technical-writer     "documente esta API no formato OpenAPI 3.0"
@deep-research-agent  "compare Redis vs Valkey para cache em 2026"
@system-architect     "projete sistema de filas para processamento assincrono"
```

---

### claude-squad — Multiplos agentes em paralelo

Gerencia varias instancias do Claude Code ao mesmo tempo, cada uma com seu proprio workspace git isolado.

**Requisito:** tmux (Linux/Mac) ou WSL2 (Windows — `wsl --install` no PowerShell Admin)

```bash
cs   # abre o painel
```

**Atalhos no painel:**

| Tecla | Acao |
|---|---|
| `n` | Nova sessao |
| `j` / `k` ou `↑` / `↓` | Navegar entre sessoes |
| `Enter` | Entrar na sessao / ver output |
| `s` | Commit e push da sessao |
| `c` | Pausar sessao |
| `r` | Retomar sessao pausada |
| `D` | Deletar sessao |
| `q` | Sair |

**Exemplo — frontend + backend + testes em paralelo:**
```
cs
→ n  →  "backend"   →  "implemente CRUD de usuarios com FastAPI"
→ n  →  "frontend"  →  "implemente tela de usuarios com Next.js"
→ n  →  "tests"     →  "escreva testes para a API de usuarios"
# Todos rodam ao mesmo tempo. Use j/k para acompanhar cada um.
```

**Quando usar:**

| Situacao | Ferramenta |
|---|---|
| Novo projeto do zero | GSD `/gsd-new-project` |
| Feature que depende de outra | GSD fases em sequencia |
| Features independentes simultaneas | claude-squad |
| Tarefa rapida | `/gsd-quick` |

---

### MCP Servers

**context7** — documentacao sempre atualizada:
```bash
# So adicionar "use context7" no prompt:
"como usar o App Router do Next.js 15? use context7"
"sintaxe de useEffect no React 19? use context7"
```

**sequential-thinking** — ativa automaticamente em tarefas complexas.

**filesystem** — Claude acessa seus arquivos locais com seguranca.

**Adicionar mais MCPs:**
```bash
claude mcp add github    -- npx -y "@modelcontextprotocol/server-github"
claude mcp add postgres  -- npx -y "@modelcontextprotocol/server-postgres" "postgresql://..."
claude mcp list          # ver MCPs configurados
claude mcp remove nome   # remover
```

---

### repomix — menos tokens, mais contexto

```bash
npx repomix                            # projeto inteiro
npx repomix --include "src/**/*.ts"    # so arquivos especificos
npx repomix --ignore "node_modules"    # ignorar pastas pesadas
npx repomix --compress                 # saida menor ainda
```

Gera `repomix-output.xml` — arraste para o chat do Claude Code para dar contexto completo sem abrir arquivo por arquivo.

---

### CLAUDE.md — instrucoes persistentes por projeto

Crie um `CLAUDE.md` na raiz de cada projeto. O Claude le automaticamente a cada sessao:

```markdown
# Meu Projeto

## Stack
- Backend: FastAPI + PostgreSQL
- Frontend: Next.js 15 + Tailwind
- Deploy: Railway + Vercel

## Comandos
- `npm run dev`   → dev server
- `npm test`      → testes
- `npm run lint`  → lint + format

## Convencoes
- Commits em ingles: feat/fix/docs/refactor
- camelCase para variaveis, UPPER_SNAKE para constantes
- Sempre criar testes para nova logica de negocio
```

---

## Dicas rapidas

```bash
ccusage           # ver quantos tokens consumiu
ccusage --today   # so hoje

# Atualizar tudo
npx get-shit-done-cc@latest --claude --global    # GSD
pip install --upgrade superclaude && \
  PYTHONIOENCODING=utf-8 superclaude install     # SuperClaude
```

---

## Estrutura do `~/.claude` apos o setup

```
~/.claude/
├── settings.json      # hooks GSD + statusline
├── CLAUDE.md          # instrucoes globais
├── commands/sc/       # 31 comandos SuperClaude
├── agents/            # 20 agentes SuperClaude + GSD
├── skills/            # 73 skills GSD
├── hooks/             # 8 hooks GSD
└── memory/            # auto-memoria do Claude Code
~/.claude.json         # MCP servers
```

---

## Contribuindo

Encontrou uma ferramenta que deveria estar aqui? Abra uma issue ou PR!

Por favor inclua:
- Link do repositorio original
- O que a ferramenta faz e por que merece estar no setup
- Como instalar

---

## Creditos

Este setup e uma colecao de ferramentas criadas pela comunidade.
Todo o credito vai para os autores originais — veja [CREDITS.md](CREDITS.md).

Principais projetos:
- [GSD](https://github.com/gsd-build/get-shit-done) por TACHES / gsd-build
- [SuperClaude](https://github.com/SuperClaude-Org/SuperClaude_Framework) por SuperClaude-Org
- [repomix](https://github.com/yamadashy/repomix) por yamadashy
- [claude-squad](https://github.com/smtg-ai/claude-squad) por smtg-ai
- [task-master](https://github.com/eyaltoledano/claude-task-master) por eyaltoledano
- [ccusage](https://github.com/ryoppippi/ccusage) por ryoppippi
- [context7](https://github.com/upstash/context7) por Upstash
- [MCP Servers](https://github.com/modelcontextprotocol/servers) por Anthropic

---

## Licenca

MIT — use, modifique e distribua livremente.
Veja [LICENSE](LICENSE) para detalhes.
