# Implement Command

## Purpose
Execute the implementation plan using agents for coding, exploration, and quality checks.

## Prerequisites
- `IMPLEMENTATION_PLAN.md` exists in **root directory** (run `/plan` first)
- Plan is complete and reviewed
- All required context documents have been read

## Workflow

### 1. Load Context
```bash
# Verify active task exists
if [ ! -f "IMPLEMENTATION_PLAN.md" ]; then
    echo "No active task. Run /plan first or use ./src/scripts/task.sh start"
    exit 1
fi

# Read task documents (all in root directory)
cat IMPLEMENTATION_PLAN.md
cat CHECKLIST.md
cat NOTES.md  # If exists
```

### 2. Use Agents Strategically

**`@scout`** — Use liberally throughout implementation:
- Find existing patterns before writing new code
- Locate utilities, helpers, and shared code
- Understand how similar features are structured
- Cheap and fast (runs on Haiku) — don't hesitate to use it

**`@implementer`** — For substantial coding tasks:
- Runs in an isolated git worktree — safe parallel development
- Give it a specific step from the implementation plan
- It writes code AND tests together
- Can spawn `@scout` internally for codebase questions
- Review its worktree output before merging

**`@architect`** — When you hit a design question:
- Unexpected complexity or trade-off during implementation
- Need to evaluate a different approach than planned
- Update `IMPLEMENTATION_PLAN.md` with any design changes

### 3. Implementation Loop

For each step in the plan:

#### A. Before Making Changes
- Update `CHECKLIST.md` (in root) to mark item as in-progress
- Use `@scout` to find relevant existing code
- Document any discoveries in `NOTES.md` (in root)
- If approach differs from plan, update `IMPLEMENTATION_PLAN.md` (in root)

#### B. Make Changes
- Write code following project conventions
- Add comments only where logic isn't self-evident
- Avoid over-engineering (see CLAUDE.md principles)
- Keep changes focused and atomic

#### C. Write Tests Alongside Code
- Follow patterns in `/tests/`
- Test behavior, not implementation
- Use Arrange-Act-Assert pattern
- Cover edge cases and error conditions

#### D. Verify After Each Step
```bash
npm test 2>/dev/null || pytest 2>/dev/null || go test ./... 2>/dev/null || cargo test 2>/dev/null
npm run lint 2>/dev/null
npm run typecheck 2>/dev/null
```

#### E. Update Progress
- Mark completed items in `CHECKLIST.md` (in root)
- Note any blockers or issues in `NOTES.md` (in root)
- Update `IMPLEMENTATION_PLAN.md` if approach changed
- Update status field as you progress

### 4. Handle Architectural Decisions
If you make a significant design decision during implementation:
- Use `@architect` to evaluate the trade-offs
- Use `@doc-writer` to draft the ADR
- Document using the template in `docs/adr/0001-example-decision.md`

### 5. Mid-Implementation Quality Check
Halfway through (or at natural breakpoints), run a quick check:
- Use `@qa` to review what's built so far
- Fix any issues before they compound

## Common Pitfalls

**DON'T:**
- Skip tests ("I'll add them later")
- Introduce patterns from `docs/ANTI_PATTERNS.md`
- Make changes beyond task scope
- Commit commented-out code or TODOs
- Guess at codebase patterns — use `@scout`

**DO:**
- Use `@scout` before writing anything new
- Test after every logical change
- Write self-documenting code
- Update checklist as you go
- Keep the implementation plan current

## Outputs
- Working, tested code
- Updated tests in `/tests/`
- Updated `CHECKLIST.md` (in root) with progress
- Updated `NOTES.md` (in root) with discoveries
- Updated `IMPLEMENTATION_PLAN.md` (in root) reflecting current state
- ADRs for any architectural decisions (via `@doc-writer`)

## Next Step
Run `/review` to verify completion.

---

**Important:**
- All task files stay in **root directory** during active work
- Files move to `ai/TASKS/archive/` only when task is complete
- Use `./src/scripts/task.sh finish "task-name"` to archive
