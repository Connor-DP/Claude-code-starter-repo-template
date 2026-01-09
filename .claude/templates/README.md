# Task Templates

## Purpose

These templates are used to start new tasks. They are copied to the root directory when beginning work.

## Usage

**Automated (recommended):**
```bash
./src/scripts/task.sh start "task-name"
```

This will automatically:
1. Copy all templates to root directory
2. Fill in date and task name placeholders
3. Prepare the workspace for implementation

**Manual:**
```bash
cp .claude/templates/IMPLEMENTATION_PLAN.md ./IMPLEMENTATION_PLAN.md
cp .claude/templates/CHECKLIST.md ./CHECKLIST.md
cp .claude/templates/NOTES.md ./NOTES.md
```

## Templates

### IMPLEMENTATION_PLAN.md
The authoritative source of truth for the current task. Contains:
- Objective and context
- Acceptance criteria
- Implementation approach
- Risks and considerations
- Testing strategy
- Definition of done

### CHECKLIST.md
Granular progress tracking through all phases:
- Pre-implementation checks
- Implementation items
- Testing requirements
- Security verification
- Documentation updates
- Completion criteria

### NOTES.md
Exploratory scratchpad for:
- Research findings
- Questions and answers
- Key discoveries
- References
- Temporary thoughts

**Important**: NOTES.md is ephemeral context, NOT requirements. It should not be treated as authoritative.

## Customization

Customize these templates for your project:
- Add project-specific sections
- Update acceptance criteria
- Adjust testing requirements
- Include domain-specific checks

## Workflow

1. **Start task**: Copy templates to root
2. **Fill in IMPLEMENTATION_PLAN.md**: Define what you're building
3. **Track progress in CHECKLIST.md**: Check off items as you go
4. **Document discoveries in NOTES.md**: Keep exploratory context
5. **Archive**: When done, move all three files to `ai/TASKS/archive/<date>-<slug>/`

---

**Note**: The root directory should only contain files for the CURRENT active task. Completed tasks are archived.
