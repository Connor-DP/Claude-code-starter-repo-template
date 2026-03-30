# [Your Project Name]

> [One-line description of what this project does]

## Quick Start

### Prerequisites

```bash
# Update these for your stack
node >= 20.0.0
npm >= 10.0.0
```

### Installation

```bash
git clone <your-repo-url>
cd <your-project>
npm install

# Verify environment
./src/scripts/doctor.sh
```

### Running

```bash
# Development
npm run dev

# Tests
npm test

# Build
npm run build
```

## Features

- [Feature 1]
- [Feature 2]
- [Feature 3]

## Project Structure

```
src/           — Application source code
tests/         — Test files
docs/          — Product requirements and technical specs
  adr/         — Architectural Decision Records
ai/            — AI-assisted development framework
  TASKS/       — Task lifecycle tracking
  DEFINITIONS/ — Quality and completion criteria
.claude/       — Claude Code configuration
  agents/      — Specialized AI agents
  commands/    — Workflow commands (/plan, /implement, /review)
```

## Development Workflow

This project uses AI-assisted development with Claude Code. See `CLAUDE.md` for the full workflow.

### Quick version:

```bash
# 1. Start a task
./src/scripts/task.sh start "feature-name"

# 2. Plan, implement, and review with Claude
#    Use /plan, /implement, /review commands
#    Agents: @scout, @architect, @implementer, @reviewer, @qa

# 3. Finish and archive
./src/scripts/task.sh finish "feature-name"
```

### Available Agents

| Agent | What it does |
|-------|-------------|
| `@scout` | Fast codebase search (cheap, use liberally) |
| `@architect` | System design and trade-off analysis |
| `@implementer` | Coding in isolated git worktree |
| `@reviewer` | Code review and scope discipline |
| `@qa` | Testing and bug finding |
| `@security-auditor` | OWASP and secret scanning |
| `@doc-writer` | Documentation and ADRs |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

[Your chosen license]
