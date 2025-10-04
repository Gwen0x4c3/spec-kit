# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the **GitHub Spec Kit** repository, which contains the **Specify CLI** tool for bootstrapping Spec-Driven Development (SDD) projects. The repository provides templates and tooling to help developers use AI assistants for structured software development.

**Core Purpose**: The Specify CLI (`specify`) bootstraps projects with Spec-Driven Development templates that work with multiple AI coding assistants (Claude Code, GitHub Copilot, Gemini CLI, Cursor, etc.).

**Key Insight**: This repository generates release packages that contain templates for different AI agents - it's not a typical application repository. The main output is ZIP files containing project templates.

## Key Commands

### Development Commands

- `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` - Install Specify CLI
- `specify init <project-name> --ai claude` - Initialize new project with Claude support
- `specify check` - Check required tools are installed
- `uvx --from git+https://github.com/github/spec-kit.git specify init .` - Run without installing

### Build & Release Commands

This repository uses GitHub Actions for automated releases. Manual package building:
- `.github/workflows/scripts/create-release-packages.sh <version>` - Build all template packages
- `AGENTS=claude SCRIPTS=sh .github/workflows/scripts/create-release-packages.sh v0.1.0` - Build specific variants

### Python Development

- `uv run` - Run in development mode
- `uv build` - Build package
- `uv publish` - Publish to PyPI (maintainers only)

## High-Level Architecture

### Main Components

1. **Specify CLI** (`src/specify_cli/__init__.py`) - Main CLI tool (~1160 lines)
   - Handles project initialization and AI agent selection
   - Downloads templates from GitHub releases
   - Manages template extraction and setup
   - Supports 11 AI agents with different directory structures

2. **Template System** (`templates/`) - Project templates for different AI agents
   - `plan-template.md` - Technical implementation template
   - `spec-template.md` - Specification template
   - `tasks-template.md` - Task breakdown template
   - `commands/` - AI agent command definitions

3. **Agent Support** - Multiple AI assistant integrations
   - Claude Code: `.claude/commands/`
   - Gemini CLI: `.gemini/commands/` (TOML format)
   - GitHub Copilot: `.github/prompts/`
   - Cursor: `.cursor/commands/`
   - Plus 7 other agents

4. **Build System** (`.github/workflows/scripts/`)
   - Automated package creation for all agent/script combinations
   - Version management and release automation

5. **Documentation** (`docs/`) - DocFX-generated documentation

## AI Agent Integration

The repository supports multiple AI agents with different conventions:

- **CLI Agents**: Claude, Gemini, Cursor, Qwen, opencode (require command-line tools)
- **IDE Agents**: GitHub Copilot, Windsurf (work within editors)
- **Command Formats**: Markdown (Claude, Cursor) vs TOML (Gemini, Qwen)
- **Script Types**: POSIX shell (sh) vs PowerShell (ps)

## Development Workflow

1. **Changes to CLI** (`src/specify_cli/__init__.py`) require:
   - Update `pyproject.toml` version
   - Add `CHANGELOG.md` entry
   - Test with multiple AI agents: `specify init test-project --ai claude`, `--ai copilot`, etc.

2. **Adding New AI Agent** requires updates to:
   - `AI_CHOICES` constant in `__init__.py`
   - Agent directory mapping
   - Release package script
   - Update scripts (bash + PowerShell)
   - README documentation

3. **Template Changes** automatically flow to all generated projects

## Important Files

- `pyproject.toml` - Python package configuration
- `src/specify_cli/__init__.py` - Main CLI implementation
- `templates/commands/*.md` - AI command definitions
- `.github/workflows/scripts/create-release-packages.sh` - Package building
- `AGENTS.md` - Agent integration guide
- `spec-driven.md` - SDD methodology documentation

## Common Tasks

### Adding a New AI Agent
1. Update `AI_CHOICES` and `agent_folder_map` in `__init__.py`
2. Add to `ALL_AGENTS` in release script
3. Update bash/PowerShell context scripts
4. Add case statement for directory structure
5. Update documentation

### Testing Changes
- Test CLI: `python -m src.specify_cli init test-project --ai claude --ignore-agent-tools`
- Test package building: `.github/workflows/scripts/create-release-packages.sh v9.9.9`
- Verify template generation works correctly

### Release Process
1. Commit changes to main
2. GitHub Actions automatically creates release
3. Templates are packaged for all agent/script combinations
4. ZIP files uploaded as release assets

## Notes for Claude Code

- This is a Python CLI tool with rich console output using `typer` and `rich`
- Templates use placeholder substitution (`{SCRIPT}`, `$ARGUMENTS`, `{{args}}`)
- Agent-specific directory structures are critical
- Release process is fully automated
- Focus on backward compatibility when modifying templates