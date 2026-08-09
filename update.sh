#!/bin/bash
# Atualiza todas as ferramentas do Claude Code Setup
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

WARNINGS=()
warn() { echo -e "${YELLOW}  $1${NC}"; WARNINGS+=("$1"); }

# Deteccao minima de plataforma (mesma logica do setup.sh)
detect_platform() {
    OS_NAME="desconhecido"; OS_ID=""; PKG_FAMILY="unknown"; PKG_MGR=""

    if [ "$(uname -s)" = "Darwin" ]; then
        OS_NAME="macOS"; OS_ID="macos"; PKG_FAMILY="brew"; PKG_MGR="brew"
    elif [ -r /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        OS_ID="$ID"; OS_NAME="${PRETTY_NAME:-$ID}"
        case " $ID ${ID_LIKE:-} " in
            *" fedora "*|*" rhel "*|*" centos "*) PKG_FAMILY="rhel" ;;
            *" debian "*|*" ubuntu "*)           PKG_FAMILY="debian" ;;
        esac
    fi

    [ -n "${UCS_FORCE_FAMILY:-}" ] && { PKG_FAMILY="$UCS_FORCE_FAMILY"; PKG_MGR=""; }

    case "$PKG_FAMILY" in
        rhel)
            if   command -v dnf5 >/dev/null 2>&1; then PKG_MGR="dnf5"
            elif command -v dnf  >/dev/null 2>&1; then PKG_MGR="dnf"
            elif command -v yum  >/dev/null 2>&1; then PKG_MGR="yum"
            else PKG_MGR="dnf"; fi ;;
        debian) PKG_MGR="apt-get" ;;
        brew)   PKG_MGR="brew" ;;
    esac
}

detect_platform

case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

echo -e "${CYAN}=== ATUALIZANDO CLAUDE CODE SETUP ===${NC}"
echo -e "${NC}Plataforma: ${OS_NAME} (familia: ${PKG_FAMILY})${NC}"

# Atualiza um CLI Python pelo mesmo caminho que o setup.sh usou (pipx ou venv).
# Uso: py_cli_upgrade <pacote-pypi> <binario>
py_cli_upgrade() {
    local pkg="$1" bin="$2"
    local venv="$HOME/.claude/venv-$bin"

    if [ -x "$venv/bin/pip" ]; then
        "$venv/bin/pip" install --upgrade "$pkg" && return 0
        return 1
    fi
    if command -v pipx >/dev/null 2>&1; then
        pipx upgrade "$pkg" && return 0
        pipx install "$pkg" && return 0
        return 1
    fi
    warn "pipx nao encontrado. Instale: sudo $PKG_MGR install -y pipx  (ou rode ./setup.sh)"
    return 1
}

echo -e "\n${YELLOW}[1/5] GSD...${NC}"
if npx get-shit-done-cc@latest --claude --global; then
    echo -e "${GREEN}  GSD OK${NC}"
else
    warn "GSD falhou. Rode: npx get-shit-done-cc@latest --claude --global"
fi

# SuperClaude — Fedora/RHEL bloqueiam 'pip install' no python do sistema (PEP 668).
echo -e "\n${YELLOW}[2/5] SuperClaude...${NC}"
if py_cli_upgrade superclaude superclaude; then
    PYTHONIOENCODING=utf-8 superclaude install \
        && echo -e "${GREEN}  SuperClaude OK${NC}" \
        || warn "'superclaude install' falhou"
else
    warn "SuperClaude nao atualizado"
fi

# graphify — pacote PyPI 'graphifyy', CLI e skill 'graphify'.
echo -e "\n${YELLOW}[3/5] graphify...${NC}"
if py_cli_upgrade graphifyy graphify; then
    graphify install \
        && echo -e "${GREEN}  graphify OK${NC}" \
        || warn "'graphify install' falhou"
else
    warn "graphify nao atualizado"
fi

echo -e "\n${YELLOW}[4/5] Ferramentas npm...${NC}"
if npm update -g repomix ccusage task-master-ai; then
    echo -e "${GREEN}  npm tools OK${NC}"
else
    warn "npm update falhou. Verifique o prefix: npm config get prefix"
fi

echo -e "\n${YELLOW}[5/5] claude-squad...${NC}"
if command -v tmux >/dev/null 2>&1; then
    if curl -fsSL https://raw.githubusercontent.com/smtg-ai/claude-squad/main/install.sh | bash; then
        echo -e "${GREEN}  claude-squad OK${NC}"
    else
        warn "claude-squad falhou"
    fi
else
    warn "tmux ausente — claude-squad pulado. Instale: sudo $PKG_MGR install -y tmux"
fi

if [ ${#WARNINGS[@]} -gt 0 ]; then
    echo -e "\n${YELLOW}AVISOS (${#WARNINGS[@]}):${NC}"
    for w in "${WARNINGS[@]}"; do echo -e "${YELLOW}  - $w${NC}"; done
fi

echo -e "\n${CYAN}=================================${NC}"
echo -e "${GREEN}TUDO ATUALIZADO! Reinicie o Claude Code.${NC}"
