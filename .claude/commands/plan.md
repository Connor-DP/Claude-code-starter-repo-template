# Plan Command

## Purpose
Create a comprehensive implementation plan for a new task.

## Workflow

### 1. Understand Requirements
- Read `/CLAUDE.md` for constitutional rules
- Read `ai/DEFINITIONS/DONE_DEFINITION.md` for completion criteria
- Review relevant `/docs/` files (PRD, TECH_SPEC, ARCHITECTURE, APP_FLOW)
- Check `docs/ANTI_PATTERNS.md` for constraints

### 2. Create Task Folder
```bash
# Create dated task folder
DATE=$(date +%Y-%m-%d)
SLUG="<descriptive-task-slug>"
mkdir -p ai/TASKS/active/${DATE}-${SLUG}
```

### 3. Write Implementation Plan
Create `ai/TASKS/active/<date>-<slug>/IMPLEMENTATION_PLAN.md`:

```markdown
# Task: [Task Title]

## Objective
Clear, concise statement of what needs to be achieved.

## Context
Why is this needed? What problem does it solve?

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] All tests passing
- [ ] Documentation updated

## Approach

### High-Level Strategy
Describe the overall approach in 2-3 sentences.

### Implementation Steps
1. **Step 1**: Description
   - Substep a
   - Substep b
2. **Step 2**: Description
3. **Step 3**: Description

### Files to Modify/Create
- `path/to/file1.ts` - What changes
- `path/to/file2.ts` - What changes
- `tests/test-file.test.ts` - New tests

### Risks & Considerations
- Risk 1: Description and mitigation
- Risk 2: Description and mitigation

## Testing Strategy
- Unit tests for X
- Integration tests for Y
- Manual testing: [specific scenarios]

## Definition of Done
Reference `ai/DEFINITIONS/DONE_DEFINITION.md` + task-specific criteria:
- [ ] All acceptance criteria met
- [ ] Tests written and passing
- [ ] Code reviewed
- [ ] Documentation updated
- [ ] `src/scripts/verify-task.sh` passes
```

### 4. Create Checklist
Create `ai/TASKS/active/<date>-<slug>/CHECKLIST.md` using template from existing example.

### 5. Create Notes File
Create `ai/TASKS/active/<date>-<slug>/NOTES.md` for exploratory context.

### 6. Verify Plan
- Does it avoid patterns in `docs/ANTI_PATTERNS.md`?
- Does it satisfy `ai/DEFINITIONS/DONE_DEFINITION.md`?
- Are there architectural decisions that need ADRs?
- Is the scope reasonable and atomic?

## Outputs
- `ai/TASKS/active/<date>-<slug>/IMPLEMENTATION_PLAN.md`
- `ai/TASKS/active/<date>-<slug>/CHECKLIST.md`
- `ai/TASKS/active/<date>-<slug>/NOTES.md`
- Ready to begin implementation

## Next Step
Run `/implement` command or begin implementation following the plan.
