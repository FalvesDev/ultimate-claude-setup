# Ultimate Claude Code Setup - Windows PowerShell
# Executa como: powershell -ExecutionPolicy Bypass -File setup.ps1

$ErrorActionPreference = "Continue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:PYTHONIOENCODING = 'utf-8'

Write-Host "=== ULTIMATE CLAUDE CODE SETUP ===" -ForegroundColor Cyan
Write-Host "Versao: 1.2 | Data: 2026-04-23" -ForegroundColor Gray
Write-Host ""

# Verificar pre-requisitos
Write-Host "[1/9] Verificando pre-requisitos..." -ForegroundColor Yellow
$nodeOk = $null -ne (Get-Command node -ErrorAction SilentlyContinue)
$npmOk  = $null -ne (Get-Command npm  -ErrorAction SilentlyContinue)
$pipOk  = $null -ne (Get-Command pip  -ErrorAction SilentlyContinue)
$gitOk  = $null -ne (Get-Command git  -ErrorAction SilentlyContinue)

if (-not $nodeOk) { Write-Host "  ERRO: Node.js nao encontrado. Instale em https://nodejs.org" -ForegroundColor Red; exit 1 }
if (-not $npmOk)  { Write-Host "  ERRO: npm nao encontrado." -ForegroundColor Red; exit 1 }
if (-not $pipOk)  { Write-Host "  AVISO: pip nao encontrado. SuperClaude sera pulado." -ForegroundColor Yellow }
if (-not $gitOk)  { Write-Host "  AVISO: git nao encontrado." -ForegroundColor Yellow }

Write-Host "  Node: $(node --version)" -ForegroundColor Green
Write-Host "  npm:  $(npm --version)"  -ForegroundColor Green

# GSD - Get Shit Done
Write-Host ""
Write-Host "[2/9] Instalando GSD (Get Shit Done) globalmente..." -ForegroundColor Yellow
npx get-shit-done-cc@latest --claude --global
Write-Host "  GSD instalado!" -ForegroundColor Green

# Ferramentas NPM globais
Write-Host ""
Write-Host "[3/9] Instalando ferramentas npm globais..." -ForegroundColor Yellow

Write-Host "  -> repomix (empacotar codebase para IA)..."
npm install -g repomix 2>&1 | Out-Null
Write-Host "     repomix OK" -ForegroundColor Green

Write-Host "  -> ccusage (dashboard de uso)..."
npm install -g ccusage 2>&1 | Out-Null
Write-Host "     ccusage OK" -ForegroundColor Green

Write-Host "  -> task-master-ai (gerenciador de tarefas)..."
npm install -g task-master-ai 2>&1 | Out-Null
Write-Host "     task-master-ai OK" -ForegroundColor Green

# SuperClaude
Write-Host ""
Write-Host "[4/9] Instalando SuperClaude..." -ForegroundColor Yellow
if ($pipOk) {
    pip install superclaude 2>&1 | Out-Null
    superclaude install 2>&1
    Write-Host "  SuperClaude OK (31 comandos + 20 agentes)" -ForegroundColor Green
} else {
    Write-Host "  PULADO (pip nao disponivel)" -ForegroundColor Yellow
}

# MCP Servers
Write-Host ""
Write-Host "[5/9] Configurando MCP Servers..." -ForegroundColor Yellow

Write-Host "  -> sequential-thinking..."
claude mcp add sequential-thinking -- npx -y "@modelcontextprotocol/server-sequential-thinking" 2>&1 | Out-Null
Write-Host "     sequential-thinking OK" -ForegroundColor Green

Write-Host "  -> context7 (docs atualizadas)..."
claude mcp add context7 -- npx -y "@upstash/context7-mcp" 2>&1 | Out-Null
Write-Host "     context7 OK" -ForegroundColor Green

Write-Host "  -> filesystem..."
$homeDir = $env:USERPROFILE
claude mcp add filesystem -- npx -y "@modelcontextprotocol/server-filesystem" $homeDir 2>&1 | Out-Null
Write-Host "     filesystem OK" -ForegroundColor Green

# CLAUDE.md global
Write-Host ""
Write-Host "[6/9] Criando CLAUDE.md global..." -ForegroundColor Yellow
$claudeDir = "$env:USERPROFILE\.claude"
if (-not (Test-Path $claudeDir)) { New-Item -ItemType Directory -Path $claudeDir | Out-Null }

$claudeMd = @"
# Instrucoes Globais do Claude

## Identidade
Voce e um assistente de desenvolvimento senior. Responda sempre em portugues (pt-BR) a menos que o codigo exija ingles.

## Comportamento Padrao
- Seja conciso. Sem resumos ao final das respostas.
- Leia arquivos antes de editar.
- Nao adicione funcionalidades nao solicitadas.
- Prefira editar arquivos existentes a criar novos.
- Commits em ingles, comunicacao em portugues.

## Economia de Tokens
- Use repomix para empacotar contexto: `npx repomix`
- Adicione `use context7` em prompts para buscar docs atualizadas.
- Para tarefas simples, use `/gsd-quick` ao inves de planejar tudo.

## Ferramentas Disponiveis
- GSD: /gsd-new-project, /gsd-plan-phase, /gsd-execute-phase, /gsd-quick
- SuperClaude: /sc:implement, /sc:research, /sc:analyze, /sc:test, @backend-architect, etc.
- repomix, ccusage, task-master
- MCPs: sequential-thinking, context7, filesystem

## Stack Preferida
- Backend: Python (FastAPI/Django) ou Node.js (TypeScript)
- Frontend: Next.js + TypeScript + Tailwind
- DB: PostgreSQL
- Deploy: Docker + Vercel/Railway
"@

Set-Content -Path "$claudeDir\CLAUDE.md" -Value $claudeMd -Encoding UTF8
Write-Host "  CLAUDE.md criado em $claudeDir" -ForegroundColor Green

# Claude Squad (requer tmux via WSL2 no Windows)
Write-Host ""
Write-Host "[7/9] Claude Squad..." -ForegroundColor Yellow
$wslOk = $null -ne (Get-Command wsl -ErrorAction SilentlyContinue)
if ($wslOk) {
    Write-Host "  WSL2 detectado! Instalando claude-squad no WSL2..." -ForegroundColor Green
    wsl bash -c "curl -fsSL https://raw.githubusercontent.com/smtg-ai/claude-squad/main/install.sh | bash"
    Write-Host "  claude-squad OK — no WSL2: cs" -ForegroundColor Green
} else {
    Write-Host "  AVISO: claude-squad requer WSL2 (nao instalado)" -ForegroundColor Yellow
    Write-Host "  Para instalar WSL2:" -ForegroundColor White
    Write-Host "    1. Abra PowerShell como Administrador" -ForegroundColor Gray
    Write-Host "    2. Execute: wsl --install" -ForegroundColor Gray
    Write-Host "    3. Reinicie o PC" -ForegroundColor Gray
    Write-Host "    4. No terminal WSL2, execute: curl -fsSL https://raw.githubusercontent.com/smtg-ai/claude-squad/main/install.sh | bash" -ForegroundColor Gray
}

# Copiar ultimate-claude.md
Write-Host ""
Write-Host "[8/9] Copiando ultimate-claude.md..." -ForegroundColor Yellow
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (Test-Path "$scriptDir\docs\ultimate-claude.md") {
    Copy-Item "$scriptDir\docs\ultimate-claude.md" "$env:USERPROFILE\ultimate-claude.md" -Force
    Write-Host "  Copiado para $env:USERPROFILE\ultimate-claude.md" -ForegroundColor Green
}

# Frontend Design Plugin
Write-Host ""
Write-Host "[9/9] Instalando plugin frontend-design..." -ForegroundColor Yellow
claude plugins install frontend-design 2>&1 | Out-Null
Write-Host "  frontend-design OK (UI distintiva, sem AI slop)" -ForegroundColor Green

# Resumo
Write-Host ""
Write-Host "=================================" -ForegroundColor Cyan
Write-Host "SETUP COMPLETO!" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Instalado:" -ForegroundColor White
Write-Host "  GSD v1.36+    -> /gsd-new-project" -ForegroundColor Green
Write-Host "  SuperClaude   -> /sc:implement, @backend-architect" -ForegroundColor Green
Write-Host "  repomix        -> npx repomix" -ForegroundColor Green
Write-Host "  ccusage        -> ccusage" -ForegroundColor Green
Write-Host "  task-master    -> task-master" -ForegroundColor Green
Write-Host "  MCP: sequential-thinking, context7, filesystem" -ForegroundColor Green
Write-Host "  claude-squad  -> cs (requer WSL2)" -ForegroundColor Yellow
Write-Host "  frontend-design -> plugin ativo (UI distinctiva)" -ForegroundColor Green
Write-Host ""
Write-Host "LEIA: $env:USERPROFILE\ultimate-claude.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "REINICIE o Claude Code para ativar tudo!" -ForegroundColor Yellow
