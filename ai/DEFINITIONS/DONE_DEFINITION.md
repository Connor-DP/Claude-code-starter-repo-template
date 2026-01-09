# Definition of Done (Invariant)

## Purpose

This document defines the universal completion criteria that apply to EVERY task in this repository. These are generic, repo-wide standards. Feature-specific acceptance criteria belong in IMPLEMENTATION_PLAN.md.

## Completion Criteria

A task is considered "done" when ALL of the following are true:

### 1. Code Quality
- [ ] Code follows the project's established style guide
- [ ] No linting errors or warnings
- [ ] No type errors (if using TypeScript)
- [ ] Code is properly formatted
- [ ] Functions and modules have clear, single responsibilities

### 2. Testing
- [ ] All existing tests pass
- [ ] New functionality has appropriate test coverage
- [ ] Edge cases are tested
- [ ] Tests are meaningful and not just for coverage metrics

### 3. Documentation
- [ ] Code is self-documenting with clear naming
- [ ] Complex logic has explanatory comments
- [ ] Public APIs are documented
- [ ] README.md updated if user-facing changes
- [ ] Relevant docs/ files updated

### 4. Security & Performance
- [ ] No introduction of known security vulnerabilities
- [ ] No obvious performance regressions
- [ ] Secrets and credentials not hardcoded
- [ ] Input validation where appropriate

### 5. Integration
- [ ] Code integrates properly with existing systems
- [ ] No breaking changes without migration path
- [ ] Dependencies are up to date and justified
- [ ] Build succeeds without errors

### 6. Verification
- [ ] `src/scripts/verify-task.sh` passes all checks
- [ ] Manual testing completed for user-facing changes
- [ ] No console errors or warnings in development

### 7. Cleanup
- [ ] No commented-out code
- [ ] No debugging statements or console.logs
- [ ] No unused imports or variables
- [ ] No TODO comments without tracking issues

## Enforcement

Run the verification script before marking any task as done:

```bash
./src/scripts/verify-task.sh
```

This script is the machine-enforced gatekeeper. If it fails, the task is not done.
