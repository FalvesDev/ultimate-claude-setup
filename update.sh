#!/bin/bash
# Atualiza todas as ferramentas do Claude Code Setup
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${CYAN}=== ATUALIZANDO CLAUDE CODE SETUP ===${NC}"

echo -e "\n${YELLOW}[1/4] GSD...${NC}"
npx get-shit-done-cc@latest --claude --global
echo -e "${GREEN}  GSD OK${NC}"

echo -e "\n${YELLOW}[2/4] SuperClaude...${NC}"
pip install --upgrade superclaude 2>/dev/null || pip3 install --upgrade superclaude
PYTHONIOENCODING=utf-8 superclaude install
echo -e "${GREEN}  SuperClaude OK${NC}"

echo -e "\n${YELLOW}[3/4] Ferramentas npm...${NC}"
npm update -g repomix ccusage task-master-ai
echo -e "${GREEN}  npm tools OK${NC}"

echo -e "\n${YELLOW}[4/4] claude-squad...${NC}"
curl -fsSL https://raw.githubusercontent.com/smtg-ai/claude-squad/main/install.sh | bash
echo -e "${GREEN}  claude-squad OK${NC}"

echo -e "\n${CYAN}=================================${NC}"
echo -e "${GREEN}TUDO ATUALIZADO! Reinicie o Claude Code.${NC}"
