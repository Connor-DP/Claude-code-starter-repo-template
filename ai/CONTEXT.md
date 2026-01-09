# AI Context

This directory contains deeper, optional context for AI-assisted development.

---

## Reading Contract

### Document Authority Hierarchy

**Read these in order when starting work:**

1. **ALWAYS READ FIRST**: `/CLAUDE.md` - Constitutional rules (highest authority)
2. **STABLE & AUTHORITATIVE** (treat as requirements):
   - `/docs/PRD.md` - Product requirements
   - `/docs/TECH_SPEC.md` - Technical specifications
   - `/docs/ARCHITECTURE.md` - System architecture
   - `/docs/APP_FLOW.md` - User journeys
   - `/docs/ANTI_PATTERNS.md` - Explicit prohibitions
   - `ai/DEFINITIONS/DONE_DEFINITION.md` - Completion criteria
   - `ai/DEFINITIONS/QUALITY_BAR.md` - Code quality standards

3. **TASK-SPECIFIC & EPHEMERAL** (context, not requirements):
   - `/IMPLEMENTATION_PLAN.md` (root) - Current task plan
   - `/NOTES.md` (root) - Exploratory notes (DO NOT treat as requirements)
   - `/CHECKLIST.md` (root) - Task progress tracker

4. **HISTORICAL REFERENCE ONLY**:
   - `docs/adr/` - Past architectural decisions
   - `docs/archive/` - Deprecated documentation
   - `ai/TASKS/archive/` - Completed tasks

### Critical Rules

**DO:**
- Treat NOTES.md as exploratory context, not hard requirements
- Always verify completion with `src/scripts/verify-task.sh`
- Check `/tests/` for existing test structure before creating tests
- Log architectural decisions in `docs/adr/` using numbered ADR format

**DO NOT:**
- Invent test locations - use `/tests/` unless project specifies otherwise
- Treat archived documents (`docs/archive/`) as current guidance
- Mix task notes with architectural decisions
- Work on multiple tasks simultaneously

---

## Structure

### DEFINITIONS/
Quality standards and completion criteria that apply universally:
- `DONE_DEFINITION.md` - Universal completion criteria
- `QUALITY_BAR.md` - Code quality standards
- `REVIEW_GUIDE.md` - Review checklist and guidelines

### TASKS/
Task management and implementation tracking:
- **Active tasks live in root directory:**
  - `/IMPLEMENTATION_PLAN.md` - Task implementation plan (root)
  - `/CHECKLIST.md` - Task completion checklist (root)
  - `/NOTES.md` - Exploratory notes (root, ephemeral)
- `archive/` - Completed task history in dated folders:
  - `archive/<YYYY-MM-DD>-<task-slug>/` - Archived completed tasks

---

## How to Run Tests & Verify

```bash
# Run verification script
src/scripts/verify-task.sh

# Run tests (check /tests/README.md for project-specific commands)
npm test                    # or: pytest, cargo test, etc.

# Check doctor script for environment validation
src/scripts/doctor.sh
```

---

## Template Repository Note

This is a template repository designed to be cloned for new projects. When working in a derived project:

1. **Check project-specific conventions first** - the template provides defaults, not mandates
2. **Respect established patterns** - if the project uses different conventions, follow those
3. **Ask when unclear** - don't invent structures or locations

---

## Usage

AI agents should consult these resources as needed, but they are subordinate to the main documentation in `/docs/` and the constitutional rules in `/CLAUDE.md`.

**Key Principle**: When in doubt about document authority, refer to the hierarchy at the top of this file.
