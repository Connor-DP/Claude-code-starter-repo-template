# Task Checklist

**Task:** [Task Title]
**Started:** [YYYY-MM-DD]

---

## Setup
- [ ] Read `CLAUDE.md` and `ai/DEFINITIONS/DONE_DEFINITION.md`
- [ ] Read relevant docs (PRD, TECH_SPEC, ARCHITECTURE, ANTI_PATTERNS)
- [ ] Implementation plan filled in and reviewed
- [ ] Use `@scout` to survey existing code patterns

## Implementation
- [ ] Phase 1: [Description]
  - [ ] Step 1
  - [ ] Step 2
  - [ ] Tests for Phase 1
- [ ] Phase 2: [Description]
  - [ ] Step 1
  - [ ] Step 2
  - [ ] Tests for Phase 2

## Quality Gates
- [ ] All tests passing
- [ ] Linting passes
- [ ] Type checking passes (if applicable)
- [ ] No debug statements in source code
- [ ] No hardcoded secrets
- [ ] No anti-patterns from `docs/ANTI_PATTERNS.md`

## Review
- [ ] `src/scripts/verify-task.sh` passes
- [ ] Code review complete (`@reviewer` or manual)
- [ ] QA validation complete (`@qa` or manual)
- [ ] Security check complete (`@security-auditor` or manual)

## Documentation
- [ ] ADRs created for architectural decisions
- [ ] README updated (if user-facing changes)
- [ ] IMPLEMENTATION_PLAN.md status updated to DONE

## Archive
- [ ] `./src/scripts/task.sh finish "task-name"`
