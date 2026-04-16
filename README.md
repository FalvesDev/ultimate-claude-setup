# Ultimate Claude Code Setup

Setup completo para transformar o Claude Code num ambiente de desenvolvimento de elite.
Inclui workflow spec-driven, agentes especializados, multi-agente paralelo e MCP servers.

> Testado em: Windows 10/11, Ubuntu 22+, macOS 13+

---

## Instalacao rapida

```bash
# Windows (PowerShell como Admin)
git clone https://github.com/FalvesDev/ultimate-claude-setup.git
cd ultimate-claude-setup
powershell -ExecutionPolicy Bypass -File setup.ps1

# Linux / Mac / WSL2
git clone https://github.com/FalvesDev/ultimate-claude-setup.git
cd ultimate-claude-setup
chmod +x setup.sh && ./setup.sh
```

**Requisitos:** Node.js 18+, Python 3.10+, git, Claude Code CLI

---

## O que e instalado

| Ferramenta | Versao | Comando | Para que serve |
|---|---|---|---|
| GSD | v1.36+ | `/gsd-*` | Workflow spec-driven, context engineering |
| SuperClaude | v4.3+ | `/sc:*` e `@agente` | 31 comandos + 20 agentes especializados |
| repomix | latest | `npx repomix` | Empacota codebase para IA (economiza tokens) |
| ccusage | latest | `ccusage` | Dashboard de consumo de tokens |
| task-master | latest | `task-master` | Gerenciamento de tarefas com IA |
| claude-squad | latest | `cs` | Multi-agente paralelo (requer tmux/WSL2) |
| MCP sequential-thinking | latest | automatico | Raciocinio passo a passo |
| MCP context7 | latest | `use context7` | Documentacao atualizada em tempo real |
| MCP filesystem | latest | automatico | Acesso a arquivos locais |

---

## GSD — Get Shit Done

**Repo:** https://github.com/gsd-build/get-shit-done — 53k+ stars

O GSD resolve o maior problema do Claude Code: **context rot** — a degradacao da qualidade conforme o contexto enche. Ele divide o trabalho em fases com contexto fresco a cada execucao.

### Workflow padrao (novo projeto)

```
1. Abra uma pasta vazia no Claude Code
2. /gsd-new-project
   -> Claude faz perguntas, cria PROJECT.md, REQUIREMENTS.md, ROADMAP.md

3. /gsd-discuss-phase 1
   -> Captura decisoes de implementacao antes de planejar

4. /gsd-plan-phase 1
   -> Pesquisa o ecossistema, cria plano detalhado em XML

5. /gsd-execute-phase 1
   -> Executa em ondas paralelas (wave 1: tarefas independentes, wave 2: dependentes)

6. /gsd-verify-work 1
   -> Verificacao contra os objetivos da fase

7. /gsd-ship 1
   -> Cria PR com o trabalho verificado

8. /gsd-next
   -> Avanca automaticamente para proxima fase
```

### Comandos GSD completos

| Comando | Para que serve |
|---|---|
| `/gsd-new-project` | Inicializa projeto completo com requisitos e roadmap |
| `/gsd-quick [tarefa]` | Tarefa rapida sem overhead de planejamento |
| `/gsd-discuss-phase N` | Captura decisoes antes de planejar a fase N |
| `/gsd-plan-phase N` | Pesquisa + cria plano para fase N |
| `/gsd-execute-phase N` | Executa fase N em ondas paralelas |
| `/gsd-verify-work N` | Verifica trabalho da fase N contra objetivos |
| `/gsd-ship N` | Cria PR da fase N verificada |
| `/gsd-next` | Auto-detecta e avanca para proximo passo |
| `/gsd-complete-milestone` | Arquiva milestone e faz tag de release |
| `/gsd-new-milestone` | Inicia proximo ciclo de versao |

### Hooks instalados automaticamente

| Hook | Quando dispara | O que faz |
|---|---|---|
| gsd-context-monitor | Apos cada tool use | Avisa quando contexto esta enchendo |
| gsd-prompt-guard | Antes de Write/Edit | Detecta prompt injection |
| gsd-read-guard | Antes de Write/Edit | Forca leitura antes de editar |
| gsd-workflow-guard | Antes de Write/Edit | Garante integridade do workflow |
| gsd-session-state | Inicio de sessao | Orienta Claude sobre estado atual |
| gsd-validate-commit | Antes de git commit | Valida mensagem do commit |

---

## SuperClaude — 31 Comandos + 20 Agentes

**Repo:** https://github.com/SuperClaude-Org/SuperClaude_Framework — framework de workflow com personas especializadas.

### Como usar os comandos `/sc:`

```bash
# Implementar uma feature
/sc:implement "adicionar autenticacao JWT com refresh token"

# Pesquisa profunda
/sc:research "melhores praticas para rate limiting em APIs REST"

# Analisar codigo existente
/sc:analyze src/auth/middleware.ts

# Gerar testes
/sc:test src/services/userService.ts

# Melhorar codigo
/sc:improve "refatorar para usar async/await ao inves de callbacks"

# Design de sistema
/sc:design "arquitetura de microservicos para e-commerce"

# Debug
/sc:troubleshoot "erro 500 ao fazer login com Google OAuth"

# Documentacao
/sc:document src/api/

# Brainstorming
/sc:brainstorm "como monetizar um SaaS de produtividade"

# Build
/sc:build

# Spawn de subagentes
/sc:spawn "crie 3 agentes: um para backend, um para frontend, um para testes"
```

### Como usar os agentes `@`

Os agentes sao subagentes especializados. Use-os com `@nome` no prompt:

```bash
# Arquitetura de backend
@backend-architect "projete a camada de dados para um sistema de notificacoes"

# Arquitetura de frontend
@frontend-architect "estruture um dashboard com React Query e Zustand"

# Seguranca
@security-engineer "audite este endpoint de upload de arquivos"

# Performance
@performance-engineer "otimize estas queries N+1 no ORM"

# QA
@quality-engineer "crie suite de testes para o modulo de pagamento"

# Pesquisa profunda
@deep-research-agent "compare Redis vs Valkey para cache de sessao em 2026"

# DevOps
@devops-architect "configure CI/CD com GitHub Actions para deploy na Vercel"

# Python
@python-expert "otimize este script de processamento de dados com pandas"

# Refatoracao
@refactoring-expert "refatore este codigo legado para seguir SOLID"

# Analise de causa raiz
@root-cause-analyst "por que esta funcao falha apenas em producao?"

# Documentacao tecnica
@technical-writer "documente esta API REST no formato OpenAPI 3.0"

# Revisao propria
@self-review "revise meu ultimo commit antes de criar o PR"

# Mentor socrático
@socratic-mentor "me ajude a entender recursao com exemplos praticos"
```

---

## claude-squad — Multi-Agente Paralelo

**Repo:** https://github.com/smtg-ai/claude-squad

Gerencia multiplas instancias do Claude Code em paralelo, cada uma com seu proprio git worktree isolado.

### Requisitos

- **Linux/Mac:** tmux (`brew install tmux` ou `apt install tmux`)
- **Windows:** WSL2 (`wsl --install` no PowerShell Admin + restart)

### Instalacao (Linux/Mac/WSL2)

```bash
curl -fsSL https://raw.githubusercontent.com/smtg-ai/claude-squad/main/install.sh | bash
```

### Como usar

```bash
# Abrir o painel
cs

# Atalhos dentro do painel:
# n          -> nova sessao (pede nome e tarefa)
# j/k ou ↑↓ -> navegar entre sessoes
# Enter      -> entrar na sessao / ver output
# s          -> commit e push do trabalho da sessao
# c          -> pausar sessao (checkout)
# r          -> retomar sessao pausada
# D          -> deletar sessao
# q          -> sair do painel
```

### Exemplo pratico: frontend + backend em paralelo

```bash
cs
# Pressione 'n' -> nome: "backend-api" -> tarefa: "implemente CRUD de usuarios com FastAPI"
# Pressione 'n' -> nome: "frontend-ui" -> tarefa: "implemente tela de listagem de usuarios com Next.js"
# Pressione 'n' -> nome: "tests"       -> tarefa: "escreva testes para a API de usuarios"

# Todos rodam ao mesmo tempo!
# Use j/k para ver o progresso de cada um
# Quando terminar, 's' para commit
```

### Quando usar claude-squad vs GSD

| Situacao | Use |
|---|---|
| Projeto novo do zero | GSD `/gsd-new-project` |
| Feature que depende de outra | GSD phases em sequencia |
| Features independentes simultaneas | claude-squad |
| Bug fix simples | `/gsd-quick` |
| Exploracao / prototipo | claude-squad sessoes isoladas |

---

## MCP Servers

MCPs expandem o que o Claude consegue fazer. Ficam em `~/.claude.json`.

### sequential-thinking

Ativa automaticamente quando o Claude percebe que a tarefa e complexa. Quebra o raciocinio em passos antes de agir.

```bash
# Adicionar manualmente
claude mcp add sequential-thinking -- npx -y "@modelcontextprotocol/server-sequential-thinking"
```

### context7

Busca documentacao oficial atualizada direto dos repositorios. Elimina respostas com APIs desatualizadas.

```bash
# Usar no prompt — so adicionar "use context7":
"como usar o App Router do Next.js 15? use context7"
"qual a sintaxe de useEffect no React 19? use context7"

# Adicionar manualmente
claude mcp add context7 -- npx -y "@upstash/context7-mcp"
```

### filesystem

Permite ao Claude ler e escrever arquivos fora do diretorio atual com seguranca.

```bash
# Adicionar manualmente (substitua o caminho)
claude mcp add filesystem -- npx -y "@modelcontextprotocol/server-filesystem" "$HOME"
```

### Outros MCPs uteis (instalar quando precisar)

```bash
# GitHub — repos, issues, PRs
claude mcp add github -- npx -y "@modelcontextprotocol/server-github"

# PostgreSQL — queries em linguagem natural
claude mcp add postgres -- npx -y "@modelcontextprotocol/server-postgres" "postgresql://user:pass@localhost/db"

# Puppeteer — automacao de browser
claude mcp add puppeteer -- npx -y "@modelcontextprotocol/server-puppeteer"

# Gerenciar MCPs
claude mcp list
claude mcp remove nome-do-servidor
```

---

## Economia de tokens

### repomix — empacotar codebase

```bash
# Empacotar projeto inteiro
npx repomix

# So arquivos relevantes
npx repomix --include "src/**/*.ts,**/*.md"

# Ignorar pastas pesadas
npx repomix --ignore "node_modules,dist,.next"

# Saida comprimida (menor ainda)
npx repomix --compress
```

Gera `repomix-output.xml` — arraste para o chat do Claude Code para dar contexto completo do projeto sem abrir arquivo por arquivo.

### ccusage — monitorar consumo

```bash
ccusage          # resumo geral
ccusage --today  # so hoje
ccusage --json   # saida em JSON para scripts
```

---

## Dicas de uso

### CLAUDE.md — instrucoes persistentes

Crie um `CLAUDE.md` na raiz de cada projeto. O Claude le automaticamente a cada sessao:

```markdown
# Meu Projeto

## Stack
- Backend: FastAPI + PostgreSQL
- Frontend: Next.js 15 + Tailwind
- Deploy: Railway + Vercel

## Comandos importantes
- `npm run dev` — inicia dev server
- `npm test` — roda testes
- `npm run lint` — lint + format

## Convencoes
- Commits em ingles, no formato: feat/fix/docs/refactor
- Variaveis em camelCase, constantes em UPPER_SNAKE_CASE
- Sempre criar testes para nova logica de negocio
```

### Modelo certo para cada tarefa

| Tarefa | Modelo recomendado |
|---|---|
| Planejamento / arquitetura | Opus 4.6 |
| Implementacao dia a dia | Sonnet 4.6 (padrao) |
| Tarefas simples / lint | Haiku 4.5 |

---

## Estrutura do `~/.claude` apos setup

```
~/.claude/
├── settings.json      # hooks GSD + statusline
├── CLAUDE.md          # instrucoes globais
├── commands/sc/       # 31 comandos SuperClaude
├── agents/            # 20 agentes SuperClaude + agentes GSD
├── skills/            # 73 skills GSD
├── hooks/             # 8 hooks GSD (context, guard, etc.)
└── memory/            # auto-memoria persistente
~/.claude.json         # MCP servers configurados
```

---

## Atualizacoes

```bash
# GSD
npx get-shit-done-cc@latest --claude --global

# SuperClaude
pip install --upgrade superclaude
$env:PYTHONIOENCODING='utf-8'; superclaude install   # Windows
PYTHONIOENCODING=utf-8 superclaude install            # Linux/Mac

# claude-squad (Linux/Mac/WSL2)
curl -fsSL https://raw.githubusercontent.com/smtg-ai/claude-squad/main/install.sh | bash
```

---

## Historico de commits

| Commit | O que mudou |
|---|---|
| `c7f76c4` | Setup inicial: scripts + ultimate-claude.md |
| `d61bb36` | INSTALL_LOG completo + correcao docs MCP |
| `acc61e5` | claude-squad adicionado aos scripts |
| `(atual)` | README detalhado + WSL2 instalado |

---

*Repo privado: https://github.com/FalvesDev/ultimate-claude-setup*
