# Implementation Plan: [Task Title]

**Status:** `NOT_STARTED`
**Started:** [YYYY-MM-DD]
**Target:** [YYYY-MM-DD or N/A]

---

## Objective

[What needs to be achieved — 1-2 sentences max]

## Context

[Why this is needed. Link to PRD section, issue, or user request if applicable]

**Related Documents:**
- [docs/PRD.md](docs/PRD.md) — Section: [X]
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — Component: [Y]

---

## Acceptance Criteria

- [ ] [Specific, testable criterion 1]
- [ ] [Specific, testable criterion 2]
- [ ] All tests passing
- [ ] No anti-patterns introduced (checked against `docs/ANTI_PATTERNS.md`)
- [ ] Documentation updated

---

## Approach

### High-Level Strategy

[2-3 sentences describing the overall approach. Use `@architect` agent for design help.]

### Implementation Steps

#### Phase 1: [Name]
1. **[Step]**: [Description]
   - [Substep]
   - [Substep]
2. **[Step]**: [Description]

#### Phase 2: [Name]
1. **[Step]**: [Description]

### Files to Modify/Create

| File | Action | Description |
|------|--------|-------------|
| `path/to/file.ts` | Modify | [What changes] |
| `path/to/new.ts` | Create | [What it does] |
| `tests/file.test.ts` | Create | [What it tests] |

---

## Architectural Decisions

[List any decisions that need ADRs. Use `@architect` agent to evaluate trade-offs.]

- [ ] [Decision 1]: [Brief rationale]

---

## Testing Strategy

- **Unit tests:** [What to test]
- **Integration tests:** [What to test]
- **Manual testing:** [Specific scenarios to verify]

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| [Risk 1] | High/Medium/Low | [How to handle] |

---

## Definition of Done

- [ ] All acceptance criteria met
- [ ] `src/scripts/verify-task.sh` passes
- [ ] `@reviewer` approves (or manual review complete)
- [ ] `@qa` finds no critical/high bugs (or manual QA complete)
- [ ] `@security-auditor` passes (or manual security check)
- [ ] ADRs created for any architectural decisions
