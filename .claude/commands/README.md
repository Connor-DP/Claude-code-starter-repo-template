# Claude Commands

## Purpose
These command files provide standardized workflows for common AI-assisted development tasks. They ensure consistency and completeness across all work.

## Available Commands

### `/plan` - Create Implementation Plan
Create a comprehensive plan before starting implementation.

**When to use:**
- Starting a new feature
- Beginning a major refactoring
- Planning a bug fix that affects multiple areas
- Any non-trivial work

**Output:** Task folder with IMPLEMENTATION_PLAN.md, CHECKLIST.md, NOTES.md

**Read:** [plan.md](./plan.md)

---

### `/implement` - Execute Implementation
Follow the implementation plan systematically.

**When to use:**
- After creating a plan
- When you have clear requirements
- For executing predefined tasks

**Output:** Working code, tests, documentation

**Read:** [implement.md](./implement.md)

---

### `/review` - Verify Completion
Comprehensive quality check before marking done.

**When to use:**
- After implementation is complete
- Before archiving a task
- Before creating a pull request
- When verifying quality

**Output:** Verification that all criteria are met

**Read:** [review.md](./review.md)

---

### `/migrate` - Refactor Legacy Code
Migrate legacy code to current architectural standards.

**When to use:**
- Refactoring old code to new patterns
- Removing anti-patterns from existing code
- Updating code to match ARCHITECTURE.md
- Bringing legacy modules up to quality standards

**Output:** Modernized code following current standards

**Read:** [migrate.md](./migrate.md)

---

## Usage

### For AI Agents
When the user mentions a command (e.g., "run /plan"), follow the workflow in that command file exactly. These are designed to reduce variance and ensure completeness.

### For Human Developers
These documents also serve as checklists and guides for manual development work. Follow them when working without AI assistance to maintain consistency.

## Command Workflow

### New Feature Development
```
/plan → /implement → /review → archive
```

### Iterative Development
```
/plan → /implement → /review (issues found) → /implement → /review → archive
```

### Legacy Code Migration
```
/migrate → /plan (migration strategy) → /implement → /review → archive
```

## Customization

These commands are templates. Customize them for your project:
- Add project-specific steps
- Adjust verification criteria
- Include custom tooling
- Add domain-specific checks

## Integration with CLAUDE.md

These commands implement the workflows defined in `/CLAUDE.md`. They are subordinate to constitutional rules but provide detailed procedures for common scenarios.

## Future Commands

Consider adding for your project:
- `/debug` - Debugging workflow
- `/deploy` - Deployment checklist
- `/document` - Documentation generation
- `/security` - Security audit workflow
- `/performance` - Performance optimization workflow

---

**Note:** These are workflow guides, not executable scripts. AI agents should follow them step-by-step, and humans can use them as checklists.
