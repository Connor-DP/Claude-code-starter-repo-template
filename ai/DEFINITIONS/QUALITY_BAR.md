# Quality Bar

**Purpose:** Defines minimum quality standards for code in this project.

**Note:** These are **default standards**. Customize for your project in `.claude/settings.json` or this file.

---

## Code Quality Standards

### Code Style & Formatting
- **Default:** Follow language conventions (PEP 8 for Python, Airbnb for JavaScript, etc.)
- **Linting:** All code must pass linter without errors
- **Formatting:** Use project formatter (Prettier, Black, rustfmt, gofmt, etc.)
- **Consistency:** Match existing code style in the project

**No hard coverage requirement by default**, but aim for:
- Critical paths: 90%+ coverage
- Business logic: 80%+ coverage
- UI components: 60%+ coverage (if applicable)

**Customize:** Set specific thresholds in your test configuration or CI/CD.

### Performance Benchmarks
- **API Endpoints:** p95 response time < 500ms (unless specified otherwise)
- **Database Queries:** No N+1 queries
- **Build Time:** Reasonable for project size (no hard limit by default)
- **Bundle Size:** Monitor growth, flag significant increases in PRs

**Customize:** Define specific benchmarks for performance-critical operations.

### Security Standards
- **Required:**
  - No hardcoded secrets (API keys, passwords, tokens)
  - Input validation on all user inputs
  - Output encoding to prevent XSS
  - Parameterized queries to prevent SQL injection
  - Dependencies updated (no high/critical vulnerabilities)

- **Recommended:**
  - HTTPS in production
  - Authentication on protected routes
  - Rate limiting on public APIs
  - CSRF protection where applicable

**Refer to:** [docs/ANTI_PATTERNS.md](../../docs/ANTI_PATTERNS.md) for prohibited patterns.

### Documentation Requirements
- **Code Comments:**
  - Explain WHY, not WHAT
  - Complex algorithms require explanation
  - No obvious comments (e.g., `// increment counter` for `i++`)

- **API Documentation:**
  - All public APIs documented
  - Request/response examples provided
  - Error codes explained

- **README:**
  - Setup instructions clear
  - Dependencies documented
  - Examples included

- **ADRs:**
  - Significant architectural decisions documented in `docs/adr/`
  - See [docs/adr/README.md](../../docs/adr/README.md) for when to create ADRs

---

## Test Coverage

### Default Policy
**No mandatory minimum coverage percentage.**

Instead, focus on:
- **Critical paths must be tested** (authentication, payments, data loss scenarios)
- **Business logic must be tested** (calculations, validations, state transitions)
- **Edge cases must be tested** (null, empty, boundary values)
- **Error handling must be tested** (what happens when things fail)

### When Coverage Matters
Set explicit thresholds for:
- Security-critical code: 95%+
- Financial calculations: 95%+
- Data processing pipelines: 90%+

### When Coverage Doesn't Matter
Don't obsess over coverage for:
- Trivial getters/setters
- Framework boilerplate
- Simple UI components
- Generated code

**Quality over quantity:** 80% coverage with meaningful tests beats 100% coverage with shallow tests.

---

## Review Criteria

All code must meet these standards during review:

### 1. Functionality Correctness
- [ ] Meets all acceptance criteria from IMPLEMENTATION_PLAN.md
- [ ] No regressions introduced
- [ ] Edge cases handled
- [ ] Error conditions handled gracefully

### 2. Code Maintainability
- [ ] Code is readable and self-documenting
- [ ] Functions/methods have single responsibility
- [ ] No duplication (DRY principle applied reasonably)
- [ ] No "clever" code that sacrifices clarity
- [ ] Complexity is justified (not over-engineered)

### 3. Testing
- [ ] Critical paths have tests
- [ ] Tests are clear and maintainable
- [ ] Tests actually test behavior (not implementation details)
- [ ] No flaky tests

### 4. Performance
- [ ] No obvious performance issues
- [ ] Database queries optimized
- [ ] No unnecessary re-renders (in UI frameworks)
- [ ] Large datasets handled appropriately

### 5. Security
- [ ] No secrets in code
- [ ] User inputs validated
- [ ] SQL injection prevented (parameterized queries)
- [ ] XSS prevented (output encoding)
- [ ] Authentication/authorization correct

### 6. Anti-Patterns
- [ ] No patterns from [docs/ANTI_PATTERNS.md](../../docs/ANTI_PATTERNS.md)
- [ ] No console.log in production code
- [ ] No commented-out code
- [ ] No untracked TODO comments

### 7. Documentation
- [ ] Complex logic has explanatory comments
- [ ] Public APIs documented
- [ ] README updated if user-facing changes
- [ ] ADR created if architectural decision made

---

## Flexibility Guidelines

### When to Be Strict
- **Security:** Never compromise
- **Data integrity:** Never compromise
- **Critical paths:** High standards required
- **Public APIs:** Breaking changes need care

### When to Be Pragmatic
- **Prototypes/MVPs:** Lower coverage acceptable with plan to improve
- **Internal tools:** Lower bar than production code
- **Spike/research code:** Exploratory code exempt (but document findings)
- **Hotfixes:** Fix first, improve later (but track tech debt)

---

## Customization

This file contains **sensible defaults**. Customize for your project:

### Option 1: Edit This File
Modify sections above to match your standards.

### Option 2: Use Project Config
Define in:
- `.claude/settings.json` - For AI guidance
- `package.json` / `pyproject.toml` - For tooling
- `.github/workflows/` - For CI/CD enforcement

### Option 3: Link to External Standards
Reference your company/team standards:
```markdown
## Our Standards
This project follows [Company Engineering Standards](link-to-your-standards).

Additions specific to this project:
- [List project-specific additions]
```

---

## Enforcement

Quality standards are enforced by:
1. **Manual review:** Pull request reviews
2. **Automated checks:** `./src/scripts/verify-task.sh`
3. **CI/CD:** GitHub Actions (see `.github/workflows/`)
4. **Pre-commit hooks:** Installed by `./src/scripts/task.sh start`

---

## Philosophy

> "Perfect is the enemy of good."

These standards aim for **professional quality**, not perfection:
- Code should be maintainable, not flawless
- Tests should be meaningful, not exhaustive
- Documentation should be helpful, not comprehensive
- Process should enable, not constrain

**The goal:** Ship high-quality code consistently, not achieve impossible standards occasionally.

---

**Last Updated:** Template defaults (customize for your project)
