# Changelog

## [1.2.0] - 2026-04-23

### Adicionado
- Frontend Design Plugin (oficial Anthropic) — instalado automaticamente nos scripts Windows e Linux/Mac
- Documentacao completa do plugin em `docs/ultimate-claude.md`
- Secao do plugin no README com exemplos de uso e dicas

### Corrigido
- Contador de passos inconsistente nos scripts (`[1/7]` a `[7/8]` corrigido para `[1/9]` a `[9/9]`)
- `setup.sh` agora detecta `pip3` como fallback quando `pip` nao esta disponivel

---

## [1.0.1] - 2026-04-16

### Alterado
- Movidos `ultimate-claude.md` e `INSTALL_LOG.md` para a pasta `docs/`
- README atualizado com secao de documentacao e links para `docs/`
- Scripts de instalacao ajustados para referenciar novo caminho `docs/ultimate-claude.md`

---

## [1.0.0] - 2026-04-16

### Adicionado
- Script de instalacao Windows (`setup.ps1`)
- Script de instalacao Linux/Mac (`setup.sh`)
- GSD v1.36 — workflow spec-driven + 8 hooks + 73 skills
- SuperClaude v4.3 — 31 comandos + 20 agentes
- repomix — empacotador de codebase para IA
- ccusage — dashboard de tokens
- task-master-ai — gerenciamento de tarefas
- claude-squad — multi-agente paralelo (requer tmux/WSL2)
- MCP: sequential-thinking, context7, filesystem
- CLAUDE.md global template
- README completo em PT-BR com guia de uso de agentes
- CREDITS.md com creditos a todos os projetos originais
- Licenca MIT
