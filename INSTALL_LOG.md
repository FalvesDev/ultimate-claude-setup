# Referencia de Instalacao

Registro tecnico completo de tudo que e instalado e configurado por este setup.
Util para entender o que cada ferramenta faz e como foi integrada.

---

## Ambiente suportado

| Sistema | Status |
|---|---|
| Windows 10/11 (Node + Python + Git) | Testado |
| Ubuntu 22+ | Testado |
| macOS 13+ | Testado |
| WSL2 (Windows) | Necessario para claude-squad |

**Versoes minimas recomendadas:**
- Node.js 18+ (testado em v24)
- npm 9+ (testado em v11)
- Python 3.10+ (testado em 3.12)
- git 2.40+

---

## 1. GSD — Get Shit Done v1.36+

**Repositorio:** https://github.com/gsd-build/get-shit-done

**Comando de instalacao:**
```bash
npx get-shit-done-cc@latest --claude --global
```

**O que e instalado em `~/.claude/`:**
- 73 skills em `~/.claude/skills/`
- Agentes GSD em `~/.claude/agents/`
- Arquivo `~/.claude/get-shit-done`
- `~/.claude/VERSION`
- `~/.claude/package.json`
- `~/.claude/gsd-file-manifest.json`

**Hooks adicionados automaticamente ao `~/.claude/settings.json`:**

| Hook | Evento | Funcao |
|---|---|---|
| gsd-check-update.js | SessionStart | Verifica atualizacao do GSD |
| gsd-session-state.sh | SessionStart | Orienta Claude sobre estado atual |
| gsd-context-monitor.js | PostToolUse (Bash,Edit,Write,Agent,Task) | Monitora uso do contexto |
| gsd-phase-boundary.sh | PostToolUse (Write,Edit) | Detecta transicoes de fase |
| gsd-prompt-guard.js | PreToolUse (Write,Edit) | Protege contra prompt injection |
| gsd-read-guard.js | PreToolUse (Write,Edit) | Forca leitura antes de editar |
| gsd-workflow-guard.js | PreToolUse (Write,Edit) | Guarda de integridade do workflow |
| gsd-validate-commit.sh | PreToolUse (Bash) | Valida commits git |

**StatusLine configurada:**
```json
"statusLine": {
  "type": "command",
  "command": "node \"~/.claude/hooks/gsd-statusline.js\""
}
```

**Comandos disponiveis:**
```
/gsd-new-project       /gsd-discuss-phase     /gsd-plan-phase
/gsd-execute-phase     /gsd-verify-work       /gsd-ship
/gsd-quick             /gsd-next              /gsd-complete-milestone
/gsd-new-milestone     (+ 63 outros skills)
```

---

## 2. repomix

**Repositorio:** https://github.com/yamadashy/repomix

**Instalacao:**
```bash
npm install -g repomix
```

**Uso:**
```bash
npx repomix                           # empacota projeto inteiro
npx repomix --include "src/**/*.ts"   # so arquivos especificos
npx repomix --compress                # saida comprimida
```
Gera `repomix-output.xml` otimizado para IA.

---

## 3. ccusage

**Repositorio:** https://github.com/ryoppippi/ccusage

**Instalacao:**
```bash
npm install -g ccusage
```

**Uso:**
```bash
ccusage           # resumo geral
ccusage --today   # so hoje
ccusage --json    # saida JSON
```

---

## 4. task-master-ai

**Repositorio:** https://github.com/eyaltoledano/claude-task-master

**Instalacao:**
```bash
npm install -g task-master-ai
```

**Comando:** `task-master`

---

## 5. SuperClaude v4.3+

**Repositorio:** https://github.com/SuperClaude-Org/SuperClaude_Framework

**Instalacao:**
```bash
pip install superclaude

# Windows (fix de encoding para emojis)
$env:PYTHONIOENCODING = 'utf-8'
superclaude install

# Linux/Mac
PYTHONIOENCODING=utf-8 superclaude install
```

**31 comandos instalados em `~/.claude/commands/sc/`:**
```
/agent        /analyze      /brainstorm   /build        /business-panel
/cleanup      /design       /document     /estimate     /explain
/git          /help         /implement    /improve      /index-repo
/index        /load         /pm           /README       /recommend
/reflect      /research     /save         /sc           /select-tool
/spawn        /spec-panel   /task         /test         /troubleshoot
/workflow
```

**20 agentes instalados em `~/.claude/agents/`:**
```
@backend-architect      @business-panel-experts  @deep-research-agent
@deep-research          @devops-architect        @frontend-architect
@learning-guide         @performance-engineer    @pm-agent
@python-expert          @quality-engineer        @refactoring-expert
@repo-index             @requirements-analyst    @root-cause-analyst
@security-engineer      @self-review             @socratic-mentor
@system-architect       @technical-writer
```

---

## 6. MCP Servers

MCPs ficam em `~/.claude.json` e sao gerenciados via `claude mcp add`.

**Instalacao:**
```bash
claude mcp add sequential-thinking -- npx -y "@modelcontextprotocol/server-sequential-thinking"
claude mcp add context7            -- npx -y "@upstash/context7-mcp"
claude mcp add filesystem          -- npx -y "@modelcontextprotocol/server-filesystem" "$HOME"
```

| MCP | Para que serve | Como usar |
|---|---|---|
| sequential-thinking | Raciocinio em passos logicos | Automatico em tarefas complexas |
| context7 | Docs atualizadas em tempo real | Adicione `use context7` no prompt |
| filesystem | Acesso a arquivos locais | Automatico |

---

## 7. claude-squad

**Repositorio:** https://github.com/smtg-ai/claude-squad

**Requisito:** tmux (Linux/Mac) ou WSL2 (Windows)

**Instalacao Linux/Mac:**
```bash
# Instalar tmux se necessario
brew install tmux        # macOS
sudo apt install tmux    # Ubuntu/Debian

# Instalar claude-squad
curl -fsSL https://raw.githubusercontent.com/smtg-ai/claude-squad/main/install.sh | bash
```

**Instalacao Windows:**
```powershell
# PowerShell como Administrador
wsl --install
# Reiniciar o PC

# No terminal WSL2
curl -fsSL https://raw.githubusercontent.com/smtg-ai/claude-squad/main/install.sh | bash
```

**Uso:** `cs`

---

## 8. Correcoes e notas tecnicas

- **`settings.json` NAO aceita `mcpServers`** — MCPs ficam em `~/.claude.json` via `claude mcp add`
- **SuperClaude no Windows** requer `PYTHONIOENCODING=utf-8` por causa de emojis no output
- **WSL2 no Windows 10/11** requer restart apos `wsl --install` para ativar

---

## 9. Estrutura final do `~/.claude`

```
~/.claude/
├── settings.json      # hooks GSD + statusline
├── CLAUDE.md          # instrucoes globais (criado pelo setup)
├── commands/sc/       # 31 comandos SuperClaude
├── agents/            # 20 agentes SuperClaude + agentes GSD
├── skills/            # 73 skills GSD
├── hooks/             # 8 hooks GSD
└── memory/            # auto-memoria persistente do Claude Code
~/.claude.json         # MCP servers (sequential-thinking, context7, filesystem)
```
