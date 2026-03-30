# AI-Assisted Development Template

> **A production-ready framework for building software with Claude Code**

Stop fighting with context loss, scope creep, and inconsistent AI output. This template gives you a constitutional framework with specialized agents, automated quality gates, and a disciplined task lifecycle.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

---

> **README files:**
> - **`README.md`** (this file) — explains the template (for GitHub visitors)
> - **`README_PROJECT.md`** — template for your project's README (replace this file with it during setup)

---

## The Problem

When building with AI coding assistants:
- **No structure** — AI creates files everywhere, no consistency
- **Context loss** — re-explaining the same things every conversation
- **Scope creep** — AI adds features you didn't ask for
- **No quality gates** — how do you know when something is actually "done"?
- **No specialization** — one AI tries to be architect, coder, reviewer, and QA simultaneously

## What This Template Does

### 1. Specialized AI Agents

Seven agents with enforced roles — they literally cannot do things outside their scope:

| Agent | Role | Tools | Model |
|-------|------|-------|-------|
| `@scout` | Fast codebase search | Read-only | Haiku (cheap) |
| `@architect` | System design, trade-off analysis | Read-only + Web | Inherit |
| `@implementer` | Code writing and testing | Full access | Inherit |
| `@reviewer` | Code review, scope discipline | Read-only + Bash | Inherit |
| `@qa` | Testing, bug finding | Read-only + Bash | Inherit |
| `@security-auditor` | OWASP, secrets, dependency audit | Read-only + Bash | Inherit |
| `@doc-writer` | Documentation, ADRs | Read + Write | Sonnet |

Key design: reviewers **cannot edit code**. The architect **cannot write implementation**. The scout is **cheap enough to use constantly**.

### 2. Agent-Powered Workflow

```
/plan                    /implement                /review
┌──────────────┐        ┌──────────────┐         ┌──────────────────┐
│ @scout       │───────▶│ @scout       │────────▶│ @reviewer        │
│ @architect   │        │ @implementer │         │ @qa              │ (parallel)
│              │        │ @architect   │         │ @security-auditor│
│              │        │ @doc-writer  │         │ @doc-writer      │
└──────────────┘        └──────────────┘         └──────────────────┘
```

The `/review` command runs three independent agents **simultaneously** — code review, QA, and security audit all at once.

### 3. Root-Based State Machine

- `IMPLEMENTATION_PLAN.md` in root = current active task
- Only **one task at a time** (enforced by scripts)
- Completed tasks archived to `ai/TASKS/archive/`
- Clear state: root files = active, archive = done

### 4. Automated Quality Gates

- **Claude Code hooks** — auto-lint after every file edit, block destructive commands
- **Pre-commit hook** — verification runs before every commit
- **`verify-task.sh`** — config-driven checks: lint, type-check, tests, secret scanning, dependency audit
- **GitHub Actions** — auto-detects language, runs gitleaks, audits dependencies

### 5. Production Infrastructure

- `.editorconfig` for cross-editor consistency
- `.nvmrc` for Node version pinning
- PR template with verification checklist
- Issue templates (bug report, feature request)
- Multi-language support (TypeScript, Python, Go, Rust)

---

## When NOT to Use This

- **Hackathon/prototype** — too much process for throwaway code
- **Single-file scripts** — overkill for trivial changes
- **"Just vibe and code"** — this enforces discipline

For trivial fixes (typos, one-liners), the template has **Lite Mode** — skip the formal workflow and just edit. See `CLAUDE.md` for details.

## Who This IS For

- **Production teams** shipping real software with AI
- **Solo founders** building MVPs they'll hand off to developers
- **Senior engineers** who want AI to follow standards
- **Anyone** tired of AI context loss on long projects

---

## Quick Start

### 1. Clone and Initialize

```bash
git clone https://github.com/Connor-DP/Claude-code-starter-repo-template.git my-project
cd my-project
rm -rf .git && git init

chmod +x src/scripts/*.sh
./src/scripts/doctor.sh
```

### 2. Configure Your Stack

Edit `.claude/settings.json` — update the `commands` section for your language. Pre-configured examples for Python, Go, and Rust are in the `examples` section.

### 3. Define Your Project

Fill in these docs (Claude can help):
- `docs/PRD.md` — what are you building?
- `docs/TECH_SPEC.md` — how are you building it?
- `docs/APP_FLOW.md` — how do users interact?

### 4. Start Your First Task

```bash
./src/scripts/task.sh start "initial-setup"
```

Then use the agent-powered workflow:

```
/plan       # @scout explores codebase, @architect designs the approach
/implement  # @implementer builds in isolated worktree, @scout finds patterns
/review     # @reviewer + @qa + @security-auditor run in parallel
```

### 5. Archive When Done

```bash
./src/scripts/task.sh finish "initial-setup"
```

Repeat for each feature.

---

## Structure

```
.
├── CLAUDE.md                         # Constitutional rules (start here)
├── IMPLEMENTATION_PLAN.md            # Current active task (when present)
├── CHECKLIST.md                      # Progress tracking
├── NOTES.md                         # Scratchpad (not requirements)
│
├── docs/                             # Requirements (stable)
│   ├── PRD.md                        # Product vision
│   ├── TECH_SPEC.md                  # Technical stack
│   ├── ARCHITECTURE.md               # System design
│   ├── APP_FLOW.md                   # User journeys
│   ├── ANTI_PATTERNS.md              # What to avoid
│   └── adr/                          # Architectural Decision Records
│
├── ai/                               # AI development framework
│   ├── CONTEXT.md                    # Reading contract
│   ├── DEFINITIONS/                  # Quality standards
│   │   ├── DONE_DEFINITION.md        # Completion criteria
│   │   ├── QUALITY_BAR.md            # Code quality standards
│   │   └── REVIEW_GUIDE.md           # Review process
│   └── TASKS/archive/               # Completed task history
│
├── src/scripts/                      # Automation
│   ├── task.sh                       # Task lifecycle (start/finish/list)
│   ├── verify-task.sh                # Quality gate (config-driven)
│   └── doctor.sh                     # Environment diagnostics
│
├── tests/                            # All tests live here
│
└── .claude/                          # Claude Code configuration
    ├── settings.json                 # Hooks, permissions, commands
    ├── agents/                       # 7 specialized agents
    │   ├── scout.md                  # Fast codebase search (Haiku)
    │   ├── architect.md              # System design (read-only)
    │   ├── implementer.md            # Coding (worktree isolation)
    │   ├── reviewer.md               # Code review (read-only)
    │   ├── qa.md                     # Testing (read-only)
    │   ├── security-auditor.md       # Security scanning (read-only)
    │   └── doc-writer.md             # Documentation (Sonnet)
    ├── commands/                     # Workflow commands
    │   ├── plan.md                   # /plan — design with agents
    │   ├── implement.md              # /implement — build with agents
    │   ├── review.md                 # /review — parallel agent review
    │   └── migrate.md                # /migrate — legacy refactoring
    └── templates/                    # Task file templates
        ├── IMPLEMENTATION_PLAN.md
        ├── CHECKLIST.md
        └── NOTES.md
```

---

## How the Agents Work

### Tool Restrictions Enforce Roles

Each agent has a YAML frontmatter definition that restricts which tools it can use:

```yaml
# reviewer.md — cannot modify code
---
name: reviewer
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
memory: project
---
```

This means `@reviewer` can read code and run verification scripts, but **physically cannot edit files**. Same for `@qa` and `@security-auditor`.

### Agent Memory Persists Across Sessions

Agents with `memory: project` remember patterns, decisions, and recurring issues between conversations. The `@architect` remembers past design decisions. The `@qa` remembers past bug patterns.

### Model Optimization

- `@scout` runs on **Haiku** — fast and cheap, use it for every codebase question
- `@doc-writer` runs on **Sonnet** — good enough for docs, cheaper than Opus
- Everything else **inherits** your session model

### Worktree Isolation

`@implementer` runs in a **git worktree** — an isolated copy of the repo. It can experiment freely without affecting your working tree.

---

## Claude Code Hooks

The template includes real Claude Code hooks in `.claude/settings.json`:

**PostToolUse** — auto-lints JS/TS files after every Write/Edit:
```json
{
  "matcher": "Write|Edit",
  "hooks": [{
    "type": "command",
    "command": "npx eslint --fix \"$CLAUDE_TOOL_PARAM_file_path\""
  }]
}
```

**PreToolUse** — blocks destructive Bash commands:
```json
{
  "matcher": "Bash",
  "hooks": [{
    "type": "command",
    "command": "... blocks rm -rf /, DROP TABLE, DROP DATABASE ..."
  }]
}
```

---

## Commands Reference

```bash
# Task lifecycle
./src/scripts/task.sh start "task-name"     # Start new task
./src/scripts/task.sh finish "task-name"    # Archive completed task
./src/scripts/task.sh list                  # Show active/archived tasks

# Verification & diagnostics
./src/scripts/verify-task.sh                # Run quality gate
./src/scripts/doctor.sh                     # Check environment health

# Agent-powered commands (use with Claude)
/plan                                       # Design with @scout + @architect
/implement                                  # Build with @implementer + @scout
/review                                     # Parallel review (3 agents)
/migrate                                    # Refactor legacy code
```

---

## Customization

### Change Tech Stack

Edit `.claude/settings.json` — update the `commands` section:

```json
{
  "commands": {
    "test": "pytest",
    "lint": "ruff check .",
    "typecheck": "mypy .",
    "build": "python -m build",
    "format": "ruff format --check ."
  }
}
```

Ready-to-copy configs for Python, Go, and Rust are in the `examples` section.

### Add Custom Agents

Create a new `.md` file in `.claude/agents/` with YAML frontmatter:

```yaml
---
name: my-agent
description: What this agent does and when to use it
tools: Read, Grep, Glob
model: sonnet
memory: project
---

You are [role]. Your job is [responsibility].
```

### Add Custom Hooks

Add hooks to `.claude/settings.json` for automated quality enforcement:

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{ "type": "command", "command": "your-lint-command" }]
    }]
  }
}
```

---

## Key Documents

| Document | Purpose | Who Writes It |
|----------|---------|---------------|
| `CLAUDE.md` | Constitutional rules | Template (rarely change) |
| `docs/PRD.md` | Product vision | You |
| `docs/TECH_SPEC.md` | Technical stack | You or AI |
| `docs/APP_FLOW.md` | User journeys | You |
| `docs/ANTI_PATTERNS.md` | Prohibited patterns | You + AI |
| `IMPLEMENTATION_PLAN.md` | Current task | You + AI |

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines, including how to use agents when contributing.

## License

MIT License — use however you want.

---

**Ready to build?** Clone this repo and start shipping.
