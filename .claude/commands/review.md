# Review Command

## Purpose
Verify task completion and ensure all quality criteria are met before marking done.

## When to Run
- After implementation is complete
- Before marking task as done
- Before archiving the task
- Before creating a pull request

## Workflow

### 1. Automated Verification

```bash
# Run verification script
src/scripts/verify-task.sh

# Run full test suite
npm test  # or project-specific command

# Check test coverage
npm test -- --coverage

# Run linters
npm run lint

# Type checking (if applicable)
npm run typecheck

# Check for security issues
npm audit  # or equivalent
```

### 2. Manual Review Checklist

Consult `ai/DEFINITIONS/REVIEW_GUIDE.md` and verify:

#### Functionality
- [ ] All acceptance criteria met (check `IMPLEMENTATION_PLAN.md`)
- [ ] Feature works as specified
- [ ] Edge cases handled correctly
- [ ] Error handling is appropriate
- [ ] No regressions introduced

#### Code Quality
- [ ] Code is clear and self-documenting
- [ ] No unnecessary complexity
- [ ] Follows established patterns in codebase
- [ ] No patterns from `docs/ANTI_PATTERNS.md`
- [ ] No commented-out code
- [ ] No hardcoded values that should be configurable
- [ ] No exposed secrets or credentials

#### Testing
- [ ] Tests are comprehensive
- [ ] Tests follow Arrange-Act-Assert pattern
- [ ] Test names are descriptive
- [ ] Tests are in `/tests/` or project convention
- [ ] All tests passing
- [ ] Coverage meets `ai/DEFINITIONS/QUALITY_BAR.md` standards

#### Documentation
- [ ] README updated if user-facing changes
- [ ] API documentation updated if applicable
- [ ] Comments added where logic isn't obvious
- [ ] ADRs created for architectural decisions
- [ ] `IMPLEMENTATION_PLAN.md` reflects actual implementation

#### Security
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] No command injection vulnerabilities
- [ ] User input is validated
- [ ] Authentication/authorization checked
- [ ] No OWASP top 10 vulnerabilities

### 3. Completion Criteria Check

Verify against `ai/DEFINITIONS/DONE_DEFINITION.md`:
- [ ] All DONE_DEFINITION criteria satisfied
- [ ] All task-specific criteria satisfied
- [ ] `CHECKLIST.md` items all checked
- [ ] Verification script passes

### 4. Peer Review Simulation

Ask yourself:
- Would this be approved in a code review?
- Is the code maintainable by others?
- Are there any unclear parts?
- Would this confuse a new team member?

### 5. Consult Agent Personas

If needed, review with specialized perspectives:

**TECH_LEAD.md**: Code quality and maintainability
```markdown
- Is the code production-ready?
- Are there any tech debt concerns?
- Does it follow team conventions?
```

**QA_ENGINEER.md**: Testing and quality
```markdown
- Is test coverage adequate?
- Are edge cases tested?
- Are there any quality concerns?
```

**ARCHITECT.md**: Design and architecture
```markdown
- Does it fit the system architecture?
- Are there scalability concerns?
- Is this the right approach?
```

### 6. Create ADRs if Needed

If you made architectural decisions during implementation:
- [ ] Create numbered ADR in `docs/adr/`
- [ ] Update `docs/adr/README.md` index
- [ ] Document context, decision, and consequences

### 7. Final Verification

```bash
# One more full verification
src/scripts/verify-task.sh

# Ensure git status is clean (no uncommitted changes)
git status

# Review what's about to be committed
git diff --staged
```

## Decision Tree

### If Everything Passes
✅ **Proceed to completion:**
1. Update `IMPLEMENTATION_PLAN.md` - mark as complete
2. Archive the task: `mv ai/TASKS/active/<task> ai/TASKS/archive/`
3. Commit changes (if requested)
4. Create PR (if requested)

### If Issues Found
❌ **Return to implementation:**
1. Document issues in `NOTES.md`
2. Update `CHECKLIST.md` to reflect remaining work
3. Fix issues
4. Return to step 1 (Automated Verification)

### If Blocked
🚫 **Need help:**
1. Document blocker in `NOTES.md`
2. Update `IMPLEMENTATION_PLAN.md` with blocker info
3. Ask user for guidance
4. Keep task in `active/` until unblocked

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

### Coverage Below Threshold
- Add missing test cases
- Test edge cases
- Verify coverage config in `tests/README.md`

### Security Issues
- Never ignore security warnings
- Update vulnerable dependencies
- Fix the vulnerability properly
- Document mitigation in ADR if needed

## Outputs
- All checks passing
- Task ready to archive
- Confidence in production-readiness
- Clear documentation of what was built

## Next Steps
- Archive completed task
- Commit changes (if user requests)
- Create pull request (if user requests)
- Begin next task
