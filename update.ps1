# Atualiza todas as ferramentas do Claude Code Setup
# Executa como: powershell -ExecutionPolicy Bypass -File update.ps1

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:PYTHONIOENCODING = 'utf-8'

Write-Host "=== ATUALIZANDO CLAUDE CODE SETUP ===" -ForegroundColor Cyan

Write-Host "`n[1/4] GSD..." -ForegroundColor Yellow
npx get-shit-done-cc@latest --claude --global
Write-Host "  GSD OK" -ForegroundColor Green

Write-Host "`n[2/4] SuperClaude..." -ForegroundColor Yellow
pip install --upgrade superclaude 2>&1 | Out-Null
superclaude install 2>&1
Write-Host "  SuperClaude OK" -ForegroundColor Green

Write-Host "`n[3/4] Ferramentas npm..." -ForegroundColor Yellow
npm update -g repomix ccusage task-master-ai 2>&1 | Out-Null
Write-Host "  npm tools OK" -ForegroundColor Green

Write-Host "`n[4/4] claude-squad..." -ForegroundColor Yellow
$wslOk = $null -ne (Get-Command wsl -ErrorAction SilentlyContinue)
if ($wslOk) {
    wsl bash -c "curl -fsSL https://raw.githubusercontent.com/smtg-ai/claude-squad/main/install.sh | bash" 2>&1 | Out-Null
    Write-Host "  claude-squad OK" -ForegroundColor Green
} else {
    Write-Host "  PULADO (WSL2 nao disponivel)" -ForegroundColor Yellow
}

Write-Host "`n=================================" -ForegroundColor Cyan
Write-Host "TUDO ATUALIZADO! Reinicie o Claude Code." -ForegroundColor Green
