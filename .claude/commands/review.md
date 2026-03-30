# Review Command

## Purpose
Verify task completion using specialized agents for code review, QA, and security audit — run in parallel for speed.

## When to Run
- After implementation is complete
- Before marking task as done
- Before creating a pull request

## Workflow

### 1. Automated Verification
```bash
src/scripts/verify-task.sh
```

### 2. Spawn Review Agents in Parallel

Run these three agents simultaneously — they are independent and read-only:

**`@reviewer`** — Code quality and scope discipline:
- Reviews the git diff for all task changes
- Checks against `DONE_DEFINITION.md` criteria
- Verifies scope discipline (no creep)
- Runs `verify-task.sh`
- Returns: Approve / Request Changes / Block

**`@qa`** — Testing and bug finding:
- Reviews test coverage and quality
- Runs the full test suite
- Attempts to find bugs and edge cases
- Checks error handling
- Returns: QA Report with bugs and missing coverage

**`@security-auditor`** — Security scan:
- Scans for OWASP top 10 vulnerabilities
- Checks for exposed secrets and credentials
- Runs dependency audit
- Reviews auth/authz implementation
- Returns: Security Audit Report

### 3. Evaluate Results

Collect all three agent reports and evaluate:

| Agent | Verdict | Action |
|-------|---------|--------|
| `reviewer` | APPROVE | Continue |
| `reviewer` | REQUEST CHANGES | Fix issues, re-run `/review` |
| `reviewer` | BLOCK | Stop — critical issues |
| `qa` | PASS | Continue |
| `qa` | FAIL | Fix bugs, re-run `/review` |
| `security-auditor` | PASS | Continue |
| `security-auditor` | FAIL | Fix vulnerabilities immediately |

### 4. Documentation Check
If any architectural decisions were made during implementation:
- Use `@doc-writer` to create ADRs
- Verify `IMPLEMENTATION_PLAN.md` reflects what was actually built

### 5. Final Verification
```bash
# One more full verification
src/scripts/verify-task.sh

# Check git status
git status

# Review the full diff
git diff --staged
```

## Decision Tree

### All Agents Pass
Proceed to completion:
1. Update `IMPLEMENTATION_PLAN.md` (in root) - mark status as DONE
2. Archive the task: `./src/scripts/task.sh finish "task-name"`
3. Commit changes (if requested)
4. Create PR (if requested)

**Note:** The archive script automatically:
- Runs verification one last time
- Moves files from root to `ai/TASKS/archive/YYYY-MM-DD-task-name/`
- Clears root directory for next task

### Issues Found
Return to implementation:
1. Collect all issues from agent reports into `NOTES.md` (in root)
2. Update `CHECKLIST.md` (in root) to reflect remaining work
3. Update `IMPLEMENTATION_PLAN.md` (in root) status to IN_PROGRESS
4. Fix issues
5. Re-run `/review`

### Blocked
Escalate to user:
1. Document blocker in `NOTES.md` (in root)
2. Update `IMPLEMENTATION_PLAN.md` (in root) with blocker info and status BLOCKED
3. Ask user for guidance
4. Keep task files in root until unblocked

## Common Issues

### Tests Failing
- Check test output carefully
- Verify fixtures and mocks
- Ensure async operations complete
- Check for race conditions

### Linting Errors
- Run auto-fix: `npm run lint -- --fix`
- Check `.eslintrc` for project rules
- Don't disable linting to pass - fix the issue

### Security Issues
- Never ignore security warnings
- Update vulnerable dependencies
- Fix the vulnerability properly
- Document mitigation in ADR if needed

## Outputs
- Three independent agent reports (reviewer, QA, security)
- Clear pass/fail verdict
- Actionable issues list if failed
- Confidence in production-readiness if passed
- ADRs created via `@doc-writer` if needed

## Next Steps
1. Archive completed task: `./src/scripts/task.sh finish "task-name"`
2. Commit changes (if user requests)
3. Create pull request (if user requests)

---

**Important:**
- Task files live in **root directory** until archived
- Archive script handles moving files to `ai/TASKS/archive/`
- Root directory must be clear before starting next task
