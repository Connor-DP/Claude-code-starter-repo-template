# Implement Command

## Purpose
Execute the implementation plan for an active task.

## Prerequisites
- `IMPLEMENTATION_PLAN.md` exists in **root directory**
- Plan is complete and reviewed
- All required context documents have been read

## Workflow

### 1. Load Context
```bash
# Verify active task exists
if [ ! -f "IMPLEMENTATION_PLAN.md" ]; then
    echo "❌ No active task. Run /plan first or use ./src/scripts/task.sh start"
    exit 1
fi

# Read task documents (all in root directory)
cat IMPLEMENTATION_PLAN.md
cat CHECKLIST.md
cat NOTES.md  # If exists
```

### 2. Pre-Implementation Checks
- [ ] Read `docs/ANTI_PATTERNS.md` - avoid prohibited patterns
- [ ] Check `tests/README.md` - understand test conventions
- [ ] Review `docs/ARCHITECTURE.md` - follow established patterns
- [ ] Consult `.claude/agents/` if specialized expertise needed:
  - `ARCHITECT.md` for design questions
  - `QA_ENGINEER.md` for testing strategy
  - `TECH_LEAD.md` for code review concerns

### 3. Implementation Loop

For each step in the implementation plan:

#### A. Before Making Changes
- Update `CHECKLIST.md` (in root) to mark item as in-progress
- Document any discoveries in `NOTES.md` (in root)
- If approach differs from plan, update `IMPLEMENTATION_PLAN.md` (in root)

#### B. Make Changes
- Write code following project conventions
- Add comments only where logic isn't self-evident
- Avoid over-engineering (see CLAUDE.md principles)
- Keep changes focused and atomic

#### C. Write Tests
- Check `/tests/` for test structure
- Follow existing test patterns
- Test behavior, not implementation
- Use Arrange-Act-Assert pattern

#### D. Verify Changes
```bash
# Run tests
npm test  # or project-specific command

# Run linters
npm run lint

# Type check (if applicable)
npm run typecheck
```

#### E. Update Checklist
- Mark completed items in `CHECKLIST.md` (in root)
- Note any blockers or issues in `NOTES.md` (in root)

### 4. Continuous Verification
During implementation:
- Run tests frequently
- Check for security vulnerabilities (OWASP top 10)
- Ensure no accidental secrets committed
- Verify changes against acceptance criteria

### 5. Handle Architectural Decisions
If you make a significant architectural decision:

```bash
# Create new ADR
NEXT_NUM=$(ls docs/adr/ | grep -E '^[0-9]+' | sort -n | tail -1 | sed 's/^0*//' | awk '{print $1+1}')
PADDED=$(printf "%04d" $NEXT_NUM)
touch docs/adr/${PADDED}-<decision-title>.md
```

Document the decision using the template in `docs/adr/0001-example-decision.md`.

### 6. Update Progress
Keep `IMPLEMENTATION_PLAN.md` (in root) current:
- Mark completed steps
- Update estimates if scope changes
- Document deviations from original plan
- Update status field as you progress

## Common Pitfalls

**DON'T:**
- Skip tests ("I'll add them later")
- Introduce patterns from `docs/ANTI_PATTERNS.md`
- Make changes beyond the task scope
- Commit commented-out code or TODOs
- Add unnecessary abstractions
- Work on multiple tasks simultaneously

**DO:**
- Keep changes minimal and focused
- Write self-documenting code
- Test edge cases
- Update documentation as you go
- Ask for clarification if requirements are unclear

## Outputs
- Working, tested code
- Updated tests in `/tests/`
- Updated `CHECKLIST.md` (in root) with progress
- Updated `NOTES.md` (in root) with discoveries
- Updated `IMPLEMENTATION_PLAN.md` (in root) reflecting current state
- ADRs for any architectural decisions

## Next Step
Run `/review` command to verify completion before archiving task.

---

**Important:**
- All task files stay in **root directory** during active work
- Files move to `ai/TASKS/archive/` only when task is complete
- Use `./src/scripts/task.sh finish "task-name"` to archive
