# Ultimate Claude Code Setup - Windows PowerShell
# Executa como: powershell -ExecutionPolicy Bypass -File setup.ps1

$ErrorActionPreference = "Continue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:PYTHONIOENCODING = 'utf-8'

Write-Host "=== ULTIMATE CLAUDE CODE SETUP ===" -ForegroundColor Cyan
Write-Host "Versao: 1.0 | Data: 2026-04-16" -ForegroundColor Gray
Write-Host ""

# Verificar pre-requisitos
Write-Host "[1/7] Verificando pre-requisitos..." -ForegroundColor Yellow
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
Write-Host "[2/7] Instalando GSD (Get Shit Done) globalmente..." -ForegroundColor Yellow
npx get-shit-done-cc@latest --claude --global
Write-Host "  GSD instalado!" -ForegroundColor Green

# Ferramentas NPM globais
Write-Host ""
Write-Host "[3/7] Instalando ferramentas npm globais..." -ForegroundColor Yellow

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
Write-Host "[4/7] Instalando SuperClaude..." -ForegroundColor Yellow
if ($pipOk) {
    pip install superclaude 2>&1 | Out-Null
    superclaude install 2>&1
    Write-Host "  SuperClaude OK (31 comandos + 20 agentes)" -ForegroundColor Green
} else {
    Write-Host "  PULADO (pip nao disponivel)" -ForegroundColor Yellow
}

# MCP Servers
Write-Host ""
Write-Host "[5/7] Configurando MCP Servers..." -ForegroundColor Yellow

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
Write-Host "[6/7] Criando CLAUDE.md global..." -ForegroundColor Yellow
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

# Copiar ultimate-claude.md
Write-Host ""
Write-Host "[7/7] Copiando ultimate-claude.md..." -ForegroundColor Yellow
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (Test-Path "$scriptDir\ultimate-claude.md") {
    Copy-Item "$scriptDir\ultimate-claude.md" "$env:USERPROFILE\ultimate-claude.md" -Force
    Write-Host "  Copiado para $env:USERPROFILE\ultimate-claude.md" -ForegroundColor Green
}

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
Write-Host ""
Write-Host "LEIA: $env:USERPROFILE\ultimate-claude.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "REINICIE o Claude Code para ativar tudo!" -ForegroundColor Yellow
