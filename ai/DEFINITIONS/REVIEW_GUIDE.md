# Review Guide

## How Reviews Work

This project uses a **three-agent parallel review** via the `/review` command:

| Agent | Focus | Can Modify Code? |
|-------|-------|-------------------|
| `@reviewer` | Code quality, scope discipline, completion | No |
| `@qa` | Test coverage, bugs, edge cases | No |
| `@security-auditor` | OWASP, secrets, dependency vulnerabilities | No |

All three run simultaneously. All three are read-only — they find problems but cannot fix them.

## Pre-Review Checklist (Before Running /review)

Before requesting review, verify yourself:

- [ ] All tests pass (`npm test` or equivalent)
- [ ] Linting passes (`npm run lint` or equivalent)
- [ ] No debug statements in source code (console.log, print, etc.)
- [ ] No hardcoded secrets or credentials
- [ ] `IMPLEMENTATION_PLAN.md` reflects what you actually built
- [ ] `CHECKLIST.md` items are all checked
- [ ] `src/scripts/verify-task.sh` passes

## What Reviewers Look For

### 1. Scope Discipline (Most Common Issue)

**The question:** Does this PR do exactly what the task asked for — nothing more, nothing less?

Red flags:
- "While I was here, I also refactored..."
- New utility functions not required by the task
- Formatting changes in files you didn't need to touch
- Features not in the acceptance criteria

### 2. Code Quality

**The question:** Would a new team member understand this code without asking you?

Red flags:
- Functions doing multiple things
- Unclear variable names (x, temp, data, result)
- Deep nesting (>3 levels)
- Duplicated logic that should be extracted
- Comments explaining "what" instead of "why"

### 3. Security

**The question:** Could a malicious user exploit this?

Red flags:
- User input used directly in queries/commands
- Missing authentication checks on protected routes
- Secrets in code (even in tests)
- Client-side-only validation
- Overly permissive CORS or permissions

### 4. Testing

**The question:** If someone breaks this code tomorrow, will a test catch it?

Red flags:
- No tests for new business logic
- Tests that only cover the happy path
- Tests that test implementation details (brittle)
- Mocked dependencies that hide real issues

### 5. Anti-Patterns

**The question:** Does this match `docs/ANTI_PATTERNS.md`?

Common violations:
- God objects / god functions
- Magic numbers without constants
- Silent error swallowing (catch and ignore)
- Callback hell or deeply nested promises
- N+1 queries

## Review Verdicts

| Verdict | Meaning | Next Step |
|---------|---------|-----------|
| **APPROVE** | All criteria met, ready to ship | Archive task, create PR |
| **REQUEST CHANGES** | Issues found, fixable | Fix issues, re-run `/review` |
| **BLOCK** | Critical issues (security, data loss) | Stop immediately, escalate |

## Handling Disagreements

If you disagree with a review finding:
1. Check if it's a real issue or a style preference
2. If style: follow existing project conventions
3. If architectural: use `@architect` to evaluate the trade-off
4. If still disagreed: document as an ADR and get team consensus
