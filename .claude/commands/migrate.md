# Command: /migrate

**Purpose:** Refactor legacy code to match current architectural standards and patterns.

---

## When to Use This Command

Use `/migrate` when you need to:
- Refactor old code to match new patterns in [docs/ARCHITECTURE.md](../../docs/ARCHITECTURE.md)
- Remove anti-patterns identified in [docs/ANTI_PATTERNS.md](../../docs/ANTI_PATTERNS.md)
- Update code written before architectural decisions were documented
- Bring legacy modules up to current quality standards
- Migrate code from another project into this codebase

**Do NOT use this command for:**
- New feature development (use `/plan` instead)
- Bug fixes (handle directly)
- Simple refactoring of current code (handle directly)

---

## Workflow

### Phase 1: Assessment

1. **Identify the legacy code:**
   - Which files/modules need migration?
   - What patterns are they currently using?
   - Why do they need to change?

2. **Review current standards:**
   - Read [docs/ARCHITECTURE.md](../../docs/ARCHITECTURE.md) - What patterns should be used?
   - Read [docs/ANTI_PATTERNS.md](../../docs/ANTI_PATTERNS.md) - What must be avoided?
   - Check [docs/adr/](../../docs/adr/) - What decisions have been made?

3. **Document the gap:**
   - What anti-patterns exist in the legacy code?
   - What architectural principles are violated?
   - What quality standards are not met?

### Phase 2: Planning

1. **Create migration plan in `IMPLEMENTATION_PLAN.md`:**
   ```markdown
   ## Objective
   Migrate [module/feature] from legacy patterns to current architecture

   ## Current State
   - Using [old pattern]
   - Missing [required elements]
   - Violates [specific anti-patterns]

   ## Target State
   - Use [new pattern] (per ARCHITECTURE.md)
   - Add [required elements]
   - Remove [anti-patterns]

   ## Migration Strategy
   1. [Step-by-step approach]
   2. [How to preserve functionality]
   3. [Testing strategy]

   ## Risks
   - Breaking changes: [list]
   - Compatibility concerns: [list]
   - Migration complexity: [assessment]
   ```

2. **Define acceptance criteria:**
   - [ ] All anti-patterns removed
   - [ ] Follows current architectural patterns
   - [ ] All tests passing
   - [ ] No functionality lost
   - [ ] Performance maintained or improved

### Phase 3: Execution

1. **Create safety net:**
   - Ensure comprehensive tests exist BEFORE refactoring
   - If tests don't exist, write them first
   - Document current behavior

2. **Migrate incrementally:**
   - Don't refactor everything at once
   - Make small, testable changes
   - Run tests after each change
   - Commit frequently with clear messages

3. **Follow the refactoring order:**
   - **Security issues first** - Fix vulnerabilities immediately
   - **Anti-patterns next** - Remove prohibited patterns
   - **Architecture alignment** - Match current patterns
   - **Code quality** - Improve readability, maintainability
   - **Optimization** - Performance improvements (if needed)

4. **Update documentation:**
   - If migration reveals new patterns, document in ARCHITECTURE.md
   - If you make architectural decisions, create ADR
   - Update inline comments if complex logic changed

### Phase 4: Verification

1. **Run comprehensive checks:**
   ```bash
   # Run full test suite
   npm test  # or pytest, cargo test, etc.

   # Check for anti-patterns
   grep -r "console\.log" src/
   # (Check all patterns from ANTI_PATTERNS.md)

   # Run verification script
   ./src/scripts/verify-task.sh
   ```

2. **Compare before/after:**
   - Functionality identical?
   - Performance acceptable?
   - Tests all passing?
   - Documentation updated?

3. **Create ADR if significant change:**
   - Document why migration was needed
   - What patterns were changed
   - What benefits were gained

---

## Example Migration Scenarios

### Scenario 1: Remove Anti-Pattern

**Legacy Code:**
```javascript
// Anti-pattern: Hardcoded configuration
const API_URL = "https://api.example.com";
const API_KEY = "abc123";
```

**Migrated Code:**
```javascript
// Follows architecture: Environment-based configuration
const API_URL = process.env.API_URL;
const API_KEY = process.env.API_KEY;

if (!API_URL || !API_KEY) {
  throw new Error("API configuration missing");
}
```

### Scenario 2: Align with Architecture

**Legacy Code:**
```javascript
// Old pattern: Direct database access in controller
app.get('/users', (req, res) => {
  db.query('SELECT * FROM users', (err, results) => {
    res.json(results);
  });
});
```

**Migrated Code:**
```javascript
// Current architecture: Service layer pattern
app.get('/users', async (req, res) => {
  try {
    const users = await userService.findAll();
    res.json(users);
  } catch (error) {
    errorHandler(error, req, res);
  }
});
```

### Scenario 3: Update to Current Standards

**Legacy Code:**
```python
# Old: No type hints, poor error handling
def process_data(data):
    result = data.split(',')
    return result
```

**Migrated Code:**
```python
# Current standards: Type hints, validation, error handling
from typing import List

def process_data(data: str) -> List[str]:
    """Process comma-separated data into a list.

    Args:
        data: Comma-separated string

    Returns:
        List of processed items

    Raises:
        ValueError: If data is empty or invalid
    """
    if not data:
        raise ValueError("Data cannot be empty")

    return [item.strip() for item in data.split(',')]
```

---

## Migration Checklist

Use this checklist in your `CHECKLIST.md`:

### Pre-Migration
- [ ] Comprehensive tests exist for legacy code
- [ ] Current behavior is documented
- [ ] Migration plan approved
- [ ] Reviewed ARCHITECTURE.md and ANTI_PATTERNS.md

### During Migration
- [ ] Security vulnerabilities fixed
- [ ] Anti-patterns removed (checked against ANTI_PATTERNS.md)
- [ ] Follows current architecture patterns
- [ ] Tests updated for new patterns
- [ ] All tests passing after each change
- [ ] Commits are small and focused

### Post-Migration
- [ ] Full test suite passing
- [ ] No anti-patterns remain
- [ ] Documentation updated
- [ ] ADR created (if architectural change)
- [ ] Code review completed
- [ ] Performance verified

---

## Common Pitfalls

### ❌ Don't Do This

1. **Big Bang Refactoring**
   - Don't refactor everything at once
   - Migrate incrementally and test continuously

2. **Changing Behavior**
   - Migration should not change functionality
   - If behavior needs to change, that's a separate feature

3. **Skipping Tests**
   - Don't refactor without tests
   - Tests are your safety net

4. **Ignoring Anti-Patterns Document**
   - Always check ANTI_PATTERNS.md
   - Don't replace one anti-pattern with another

5. **No Documentation**
   - Document why migration was needed
   - Create ADR for significant changes

### ✅ Do This Instead

1. **Incremental Migration**
   - Small, testable changes
   - Run tests after each step
   - Commit frequently

2. **Test-Driven Migration**
   - Write tests first if they don't exist
   - Ensure tests pass before and after

3. **Document Decisions**
   - Create ADR for pattern changes
   - Update ARCHITECTURE.md if needed

4. **Review Anti-Patterns**
   - Use ANTI_PATTERNS.md as a checklist
   - Ensure all violations are removed

---

## Output Format

When migration is complete, update `IMPLEMENTATION_PLAN.md` with:

```markdown
## Migration Summary

### What Changed
- [List of files modified]
- [Patterns replaced]
- [Anti-patterns removed]

### Before/After Metrics
- Lines of code: [before] → [after]
- Test coverage: [before] → [after]
- Performance: [before] → [after]

### Breaking Changes
- [List any breaking changes]
- [Migration guide for dependents]

### ADRs Created
- [Link to ADR if created]

### Lessons Learned
- [What went well]
- [What was challenging]
- [Recommendations for future migrations]
```

---

## Related Documents

- [docs/ARCHITECTURE.md](../../docs/ARCHITECTURE.md) - Current architectural patterns
- [docs/ANTI_PATTERNS.md](../../docs/ANTI_PATTERNS.md) - Patterns to avoid
- [docs/adr/](../../docs/adr/) - Architectural decision records
- [ai/DEFINITIONS/DONE_DEFINITION.md](../../ai/DEFINITIONS/DONE_DEFINITION.md) - Completion criteria

---

**Remember:** Migration is about bringing legacy code up to current standards, not changing functionality. If you need to change behavior, that's a separate feature task.
