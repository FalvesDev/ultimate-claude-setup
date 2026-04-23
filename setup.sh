#!/bin/bash
# Ultimate Claude Code Setup - Linux/Mac
# Executa como: chmod +x setup.sh && ./setup.sh

set -e
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${CYAN}=== ULTIMATE CLAUDE CODE SETUP ===${NC}"
echo -e "${NC}Versao: 1.2 | Data: 2026-04-23${NC}"
echo ""

# Pre-requisitos
echo -e "${YELLOW}[1/9] Verificando pre-requisitos...${NC}"
command -v node >/dev/null 2>&1 || { echo -e "${RED}ERRO: Node.js nao encontrado. Instale: https://nodejs.org${NC}"; exit 1; }
command -v npm  >/dev/null 2>&1 || { echo -e "${RED}ERRO: npm nao encontrado.${NC}"; exit 1; }
echo -e "  Node: $(node --version)"
echo -e "  npm:  $(npm --version)"

# GSD
echo ""
echo -e "${YELLOW}[2/9] Instalando GSD (Get Shit Done)...${NC}"
npx get-shit-done-cc@latest --claude --global
echo -e "${GREEN}  GSD instalado!${NC}"

# NPM Tools
echo ""
echo -e "${YELLOW}[3/9] Instalando ferramentas npm globais...${NC}"
npm install -g repomix     && echo -e "${GREEN}  repomix OK${NC}"
npm install -g ccusage     && echo -e "${GREEN}  ccusage OK${NC}"
npm install -g task-master-ai && echo -e "${GREEN}  task-master-ai OK${NC}"

# SuperClaude
echo ""
echo -e "${YELLOW}[4/9] Instalando SuperClaude...${NC}"
if command -v pip >/dev/null 2>&1; then
    pip install superclaude
    PYTHONIOENCODING=utf-8 superclaude install
    echo -e "${GREEN}  SuperClaude OK (31 comandos + 20 agentes)${NC}"
elif command -v pip3 >/dev/null 2>&1; then
    pip3 install superclaude
    PYTHONIOENCODING=utf-8 superclaude install
    echo -e "${GREEN}  SuperClaude OK${NC}"
else
    echo -e "${YELLOW}  PULADO (pip nao disponivel)${NC}"
fi

# MCP Servers
echo ""
echo -e "${YELLOW}[5/9] Configurando MCP Servers...${NC}"
claude mcp add sequential-thinking -- npx -y "@modelcontextprotocol/server-sequential-thinking"
echo -e "${GREEN}  sequential-thinking OK${NC}"

claude mcp add context7 -- npx -y "@upstash/context7-mcp"
echo -e "${GREEN}  context7 OK${NC}"

claude mcp add filesystem -- npx -y "@modelcontextprotocol/server-filesystem" "$HOME"
echo -e "${GREEN}  filesystem OK${NC}"

# CLAUDE.md
echo ""
echo -e "${YELLOW}[6/9] Criando CLAUDE.md global...${NC}"
mkdir -p "$HOME/.claude"
cat > "$HOME/.claude/CLAUDE.md" << 'EOF'
# Instrucoes Globais do Claude

## Identidade
Voce e um assistente de desenvolvimento senior. Responda em portugues (pt-BR).

## Comportamento
- Seja conciso. Sem resumos ao final.
- Leia antes de editar.
- Nao adicione funcionalidades nao solicitadas.

## Economia de Tokens
- Use repomix: `npx repomix`
- Adicione `use context7` para docs atualizadas.
- Use `/gsd-quick` para tarefas simples.

## Ferramentas
- GSD: /gsd-new-project, /gsd-plan-phase, /gsd-execute-phase, /gsd-quick
- SuperClaude: /sc:implement, /sc:research, @backend-architect, etc.
- repomix, ccusage, task-master
- MCPs: sequential-thinking, context7, filesystem
EOF
echo -e "${GREEN}  CLAUDE.md criado${NC}"

# Claude Squad (requer tmux)
echo ""
echo -e "${YELLOW}[7/9] Instalando claude-squad...${NC}"
if command -v tmux >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/smtg-ai/claude-squad/main/install.sh | bash
    echo -e "${GREEN}  claude-squad OK — use: cs${NC}"
else
    echo -e "${YELLOW}  AVISO: tmux nao encontrado. Instalando...${NC}"
    if command -v brew >/dev/null 2>&1; then
        brew install tmux
        curl -fsSL https://raw.githubusercontent.com/smtg-ai/claude-squad/main/install.sh | bash
        echo -e "${GREEN}  claude-squad OK — use: cs${NC}"
    elif command -v apt-get >/dev/null 2>&1; then
        sudo apt-get install -y tmux
        curl -fsSL https://raw.githubusercontent.com/smtg-ai/claude-squad/main/install.sh | bash
        echo -e "${GREEN}  claude-squad OK — use: cs${NC}"
    else
        echo -e "${YELLOW}  PULADO — instale tmux manualmente e re-execute${NC}"
    fi
fi

# Copiar ultimate-claude.md
echo ""
echo -e "${YELLOW}[8/9] Copiando ultimate-claude.md...${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$SCRIPT_DIR/docs/ultimate-claude.md" ] && cp "$SCRIPT_DIR/docs/ultimate-claude.md" "$HOME/ultimate-claude.md"
echo -e "${GREEN}  Copiado para $HOME/ultimate-claude.md${NC}"

# Frontend Design Plugin
echo ""
echo -e "${YELLOW}[9/9] Instalando plugin frontend-design...${NC}"
claude plugins install frontend-design 2>/dev/null && echo -e "${GREEN}  frontend-design OK (UI distintiva, sem AI slop)${NC}" || echo -e "${YELLOW}  frontend-design: reinicie o Claude Code e execute 'claude plugins install frontend-design'${NC}"

echo ""
echo -e "${CYAN}=================================${NC}"
echo -e "${GREEN}SETUP COMPLETO!${NC}"
echo -e "${CYAN}=================================${NC}"
echo ""
echo -e "  GSD           -> /gsd-new-project"
echo -e "  SuperClaude   -> /sc:implement, @backend-architect"
echo -e "  repomix       -> npx repomix"
echo -e "  MCPs          -> sequential-thinking, context7, filesystem"
echo -e "  claude-squad  -> cs  (requer tmux)"
echo -e "  frontend-design -> plugin ativo (UI distintiva)"
echo ""
echo -e "${CYAN}LEIA: ~/ultimate-claude.md${NC}"
echo -e "${YELLOW}REINICIE o Claude Code para ativar tudo!${NC}"
