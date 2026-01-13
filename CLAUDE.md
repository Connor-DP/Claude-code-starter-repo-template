# Claude Constitution & Entry Point

## Purpose

This document defines hard rules, precedence order, and workflow for AI-assisted development in this repository.

**This is a template repository.** When working in a project derived from this template, respect project-specific conventions while following these constitutional rules.

## Core Principles

1. **Single Source of Truth**: All documents have a clear purpose and hierarchy
2. **State Machine Discipline**: One active task at a time, living in root directory
   - `IMPLEMENTATION_PLAN.md` in root = current active task
   - Completed tasks archived to `ai/TASKS/archive/<date>-<slug>/`
3. **Completion Rigor**: Every task must satisfy ai/DEFINITIONS/DONE_DEFINITION.md
4. **Decision Transparency**: Architectural choices are logged in docs/adr/ as numbered ADRs
5. **Test Location Discipline**: Tests live in /tests/ unless project specifies otherwise

## Document Precedence (Highest to Lowest)

**Authoritative (treat as requirements):**
1. `CLAUDE.md` (this file) - Constitutional rules
2. `IMPLEMENTATION_PLAN.md` (root) - Current active task (authoritative when present)
3. `ai/DEFINITIONS/DONE_DEFINITION.md` - Universal completion criteria
4. `docs/ANTI_PATTERNS.md` - Explicit prohibitions
5. `docs/PRD.md` - Product requirements
6. `docs/TECH_SPEC.md` - Technical implementation details (read once at task start)
7. `docs/ARCHITECTURE.md` - System architecture and design
8. `docs/APP_FLOW.md` - User journeys and state transitions

**Context & Reference (not requirements):**
9. `CHECKLIST.md` (root) - Task progress tracker
10. `NOTES.md` (root) - Exploratory notes (ephemeral, NOT requirements)
11. `docs/adr/` - Architectural decision records (historical context)
12. `docs/archive/` - Deprecated documentation (historical only)
13. `ai/CONTEXT.md` - Reading contract and usage guide
14. `ai/TASKS/archive/` - Completed task history

## Standardized Commands

For consistent workflows, use standardized commands in `.claude/commands/`:
- **`/plan`** - Create comprehensive implementation plan
- **`/implement`** - Execute implementation systematically
- **`/review`** - Verify completion before marking done

See [.claude/commands/README.md](./.claude/commands/README.md) for details.

## Workflow

**Important**: The formal workflow below is designed for **non-trivial features and changes**. For trivial fixes (typos, one-liners, formatting), see **Lite Mode** below.

### Lite Mode (For Trivial Changes)

**When to use Lite Mode:**
- Fixing typos or documentation errors
- Formatting fixes (indentation, whitespace)
- Simple one-line bug fixes
- Renaming variables for clarity
- Adding missing semicolons, imports, or simple syntax fixes
- Changes that take < 10 minutes and touch < 3 files

**Rule of thumb:** If the change is obvious, requires no architectural decisions, and can be verified in under 10 minutes, skip the formal workflow.

**Lite Mode Process:**
1. Make the change directly (no IMPLEMENTATION_PLAN.md needed)
2. Run relevant tests (`npm test` or equivalent)
3. Run linting/formatting checks if applicable
4. Commit with clear, descriptive message
5. Move on

**Example commit messages for Lite Mode:**
```
Fix typo in README.md authentication section
Update indentation in user.service.ts to match style guide
Add missing import for validateEmail function
```

**When NOT to use Lite Mode:**
- Changes affecting multiple components or files
- Anything requiring architectural decisions
- New features (even small ones)
- Refactoring that changes logic
- Database schema changes
- API contract changes

**If in doubt, use the formal workflow.** Lite Mode is an exception for obvious fixes, not the default.

---

### 1. Active State (Root Directory) - Formal Workflow

The following files in the **root directory** represent the CURRENT active task:
- **`IMPLEMENTATION_PLAN.md`**: The authoritative source of truth for what you're doing
- **`CHECKLIST.md`**: Granular progress tracking
- **`NOTES.md`**: Your scratchpad (exploratory context, NOT requirements)

**Critical**: When these files exist in root, they are the ONLY active task. No other work should be in progress.

### 2. Environment Configuration (First Task Only)

**Before starting your first task**, configure `.claude/settings.json` for your stack:

#### For Node.js/TypeScript (Default):
```json
{
  "commands": {
    "test": "npm test",
    "lint": "npm run lint",
    "typecheck": "npm run typecheck",
    "build": "npm run build",
    "format": "npm run format:check"
  },
  "verification": {
    "srcDir": "src"
  }
}
```

#### For Python:
```json
{
  "commands": {
    "test": "pytest",
    "lint": "flake8 .",
    "typecheck": "mypy .",
    "build": "python -m build",
    "format": "black --check ."
  },
  "verification": {
    "srcDir": "src"
  }
}
```

#### For Go:
```json
{
  "commands": {
    "test": "go test ./...",
    "lint": "golangci-lint run",
    "typecheck": "go vet ./...",
    "build": "go build ./...",
    "format": "gofmt -l ."
  },
  "verification": {
    "srcDir": "."
  }
}
```

#### For Rust:
```json
{
  "commands": {
    "test": "cargo test",
    "lint": "cargo clippy",
    "typecheck": "cargo check",
    "build": "cargo build",
    "format": "cargo fmt -- --check"
  },
  "verification": {
    "srcDir": "src"
  }
}
```

**Note:** See `.claude/settings.json` for example configurations. The verification script (`verify-task.sh`) reads these commands automatically.

### 3. Starting Work

**Automated (recommended):**
```bash
./src/scripts/task.sh start "task-name"
```

**Manual (if needed):**
1. Read this file first (CLAUDE.md)
2. Read ai/DEFINITIONS/DONE_DEFINITION.md to understand completion criteria
3. Read docs/TECH_SPEC.md **once** at task start to understand the stack
4. Read ai/CONTEXT.md for the reading contract and document hierarchy
5. Copy templates from `.claude/templates/` to root:
   - `IMPLEMENTATION_PLAN.md`
   - `CHECKLIST.md`
   - `NOTES.md`
6. Fill in IMPLEMENTATION_PLAN.md with task details
7. Review relevant docs/ files for context (PRD, ARCHITECTURE, APP_FLOW, ANTI_PATTERNS)
8. Check tests/README.md to understand test conventions

### 4. During Work (or use `/implement` command)

- Follow the active task in **root** `IMPLEMENTATION_PLAN.md`
- Update `CHECKLIST.md` as you complete items
- Document discoveries in `NOTES.md` (exploratory only, NOT requirements)
- Consult agent personas in .claude/agents/ when needed:
  - ARCHITECT.md for system design questions
  - QA_ENGINEER.md for testing strategy
  - TECH_LEAD.md for code review concerns
- Check docs/ANTI_PATTERNS.md before making architectural decisions
- Write tests in /tests/ (or project-specific location)
- Update `IMPLEMENTATION_PLAN.md` if approach deviates from original plan

### 5. Completing Work (or use `/review` command)

- Run `src/scripts/verify-task.sh` to validate completion
- Ensure all ai/DEFINITIONS/DONE_DEFINITION.md criteria are met
- Verify all `CHECKLIST.md` items are complete
- Run full test suite and verify coverage
- Log significant architectural decisions:
  - Create numbered ADR in docs/adr/ (e.g., 0002-<title>.md)
  - Update docs/adr/README.md index
  - Use template from docs/adr/0001-example-decision.md
- Update `IMPLEMENTATION_PLAN.md` status to READY_FOR_REVIEW or DONE

### 6. Archival

**Automated (recommended):**
```bash
./src/scripts/task.sh finish "task-name"
```

This will:
1. Run verification script
2. Move root files to `ai/TASKS/archive/<date>-<task-name>/`
3. Clear root for next task

**Manual (if needed):**
```bash
mkdir -p ai/TASKS/archive/$(date +%Y-%m-%d)-task-name
mv IMPLEMENTATION_PLAN.md CHECKLIST.md NOTES.md ai/TASKS/archive/$(date +%Y-%m-%d)-task-name/
```

## Hard Rules

### Never
- **Never** work on multiple tasks simultaneously (only one IMPLEMENTATION_PLAN.md in root)
- **Never** skip the verification script before archiving
- **Never** introduce patterns listed in docs/ANTI_PATTERNS.md
- **Never** treat NOTES.md as hard requirements (it's exploratory context)
- **Never** invent test locations - use /tests/ or ask
- **Never** treat docs/archive/ as current guidance
- **Never** leave completed tasks in root - archive them

### Always
- **Always** update root IMPLEMENTATION_PLAN.md to reflect current state
- **Always** read docs/TECH_SPEC.md once at task start (don't re-read every turn)
- **Always** log architectural decisions in docs/adr/ using numbered ADR format
- **Always** update docs/adr/README.md index when creating ADRs
- **Always** check .claude/settings.json for context limits
- **Always** archive completed tasks to ai/TASKS/archive/<date>-<slug>/
- **Always** check tests/README.md before creating tests
- **Always** use `./src/scripts/task.sh` for task lifecycle when possible

## Agent Personas

Invoke specific personas from `/.claude/agents/` when needed:
- `ARCHITECT.md` - For system design and planning
- `QA_ENGINEER.md` - For testing strategy and validation
- `TECH_LEAD.md` - For code review and quality checks

## Context Management

See `.claude/settings.json` for:
- Context window limits
- Ignored paths
- Environment-specific hints
