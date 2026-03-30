# Plan Command

## Purpose
Create a comprehensive implementation plan for a new task, using the `architect` agent for design work.

## Workflow

### 1. Check for Active Task
```bash
# Ensure no task is currently active
if [ -f "IMPLEMENTATION_PLAN.md" ]; then
    echo "Task already active. Finish current task first."
    exit 1
fi
```

**Critical:** Only ONE task can be active at a time (in root directory).

### 2. Understand Requirements
- Read [/CLAUDE.md](../../CLAUDE.md) for constitutional rules
- Read [ai/DEFINITIONS/DONE_DEFINITION.md](../../ai/DEFINITIONS/DONE_DEFINITION.md) for completion criteria
- Review relevant `/docs/` files (PRD, TECH_SPEC, ARCHITECTURE, APP_FLOW)
- Check [docs/ANTI_PATTERNS.md](../../docs/ANTI_PATTERNS.md) for constraints

### 3. Use Agents for Design

**Spawn `@scout` first** to understand the current codebase:
- What existing patterns are relevant?
- What files will likely need to change?
- Are there similar features already implemented?

**Spawn `@architect` for the design phase:**
- Evaluate approaches and trade-offs
- Design data models, API contracts, module boundaries
- Produce an ADR draft if the decision is architecturally significant
- Output a structured implementation plan

### 4. Start New Task
Use the task management script:
```bash
./src/scripts/task.sh start "descriptive-task-name"
```

This creates three files in the **root directory**:
- `IMPLEMENTATION_PLAN.md`
- `CHECKLIST.md`
- `NOTES.md`

**Note:** The script automatically installs a pre-commit hook if in a git repository.

### 5. Fill in Implementation Plan
Using the architect's output, populate `IMPLEMENTATION_PLAN.md` in the root directory:

```markdown
# Implementation Plan: [Task Title]

**Status:** IN_PROGRESS
**Started:** YYYY-MM-DD

---

## Objective
[What needs to be achieved — 1-2 sentences]

## Context
[Why this is needed — link to PRD/issue if applicable]

**Related Documents:**
- [docs/PRD.md](docs/PRD.md) - Section X
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) - Component Y

---

## Acceptance Criteria
- [ ] Criterion 1 (specific, testable)
- [ ] Criterion 2
- [ ] All tests passing
- [ ] Documentation updated
- [ ] No anti-patterns introduced

---

## Implementation Approach
[Architect's recommended approach]

### High-Level Strategy
Describe the overall approach in 2-3 sentences.

### Phase 1: [Name]
1. **Step 1**: Description
   - Substep a
   - Substep b
2. **Step 2**: Description

### Phase 2: [Name]
...

### Files to Modify/Create
- `path/to/file.ts` — [what changes]

---

## Architectural Decisions
[ADR drafts from architect, if any]

---

## Testing Strategy
- **Unit tests:** What to test
- **Integration tests:** What to test
- **Manual testing:** Specific scenarios

---

## Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| Risk 1 | High | Mitigation strategy |
| Risk 2 | Medium | Mitigation strategy |

---

## Dependencies
- External packages needed
- Internal modules affected
- Team members to consult

---

## Definition of Done
- [ ] All acceptance criteria met
- [ ] `src/scripts/verify-task.sh` passes
```

### 6. Verify Plan Quality
Before proceeding, check:
- [ ] Does it avoid patterns in [docs/ANTI_PATTERNS.md](../../docs/ANTI_PATTERNS.md)?
- [ ] Does it satisfy [ai/DEFINITIONS/DONE_DEFINITION.md](../../ai/DEFINITIONS/DONE_DEFINITION.md)?
- [ ] Are there architectural decisions that need ADRs?
- [ ] Is the scope reasonable and atomic?
- [ ] Are acceptance criteria specific and testable?
- [ ] Is the testing strategy comprehensive?

## Outputs
- `IMPLEMENTATION_PLAN.md` in **root directory** (filled in with architect's design)
- `CHECKLIST.md` in **root directory** (ready to use)
- `NOTES.md` in **root directory** (scratchpad)
- Ready to run `/implement`

## Next Step
Run `/implement` to begin building.

---

**Important Notes:**
- Files live in **root directory** during active work
- Only **one task active at a time**
- When done, files move to `ai/TASKS/archive/YYYY-MM-DD-task-name/`
- This is a **state machine** - root = active, archive = done
