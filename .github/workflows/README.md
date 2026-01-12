# GitHub Actions Workflows

This directory contains CI/CD workflows for automated quality gates.

## Available Workflows

### `verify-task.yml` - Task Quality Verification

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches

**Jobs:**

#### 1. Verify (Critical)
- ✅ Linting (code style)
- ✅ Type checking (TypeScript)
- ✅ Test suite execution
- ✅ Test coverage reporting
- ✅ Task verification script (`verify-task.sh`)
- ✅ Anti-pattern detection
- ✅ Documentation completeness

#### 2. Security (Critical)
- 🔐 Secret scanning (API keys, tokens, passwords)
- 🔐 Environment file detection (`.env` in git)

#### 3. Quality (Non-Critical)
- 📦 Unused dependency detection
- 📊 Bundle size checking

#### 4. Notify
- Reports overall status
- Fails if critical jobs fail

---

## Customization for Your Project

### 1. Update Environment Setup

Edit the "Set up environment" steps based on your stack:

**For Python:**
```yaml
- name: Set up Python
  uses: actions/setup-python@v4
  with:
    python-version: '3.11'

- name: Install dependencies
  run: |
    pip install -r requirements.txt
```

**For Go:**
```yaml
- name: Set up Go
  uses: actions/setup-go@v4
  with:
    go-version: '1.21'

- name: Install dependencies
  run: go mod download
```

**For Rust:**
```yaml
- name: Set up Rust
  uses: actions-rs/toolchain@v1
  with:
    toolchain: stable

- name: Build
  run: cargo build --verbose
```

### 2. Update Test Commands

Change test commands to match your project:

```yaml
# Node.js
- name: Run tests
  run: npm test

# Python
- name: Run tests
  run: pytest

# Go
- name: Run tests
  run: go test ./...

# Rust
- name: Run tests
  run: cargo test
```

### 3. Add Project-Specific Checks

Add custom validation steps:

```yaml
- name: Check database migrations
  run: |
    # Validate migrations are up to date
    ./scripts/check-migrations.sh

- name: Validate OpenAPI spec
  run: |
    # Validate API specification
    npx @stoplight/spectral-cli lint openapi.yaml
```

### 4. Configure Coverage Thresholds

Add coverage requirements:

```yaml
- name: Check coverage threshold
  run: |
    coverage=$(npm run test:coverage:json | jq '.total.lines.pct')
    if (( $(echo "$coverage < 80" | bc -l) )); then
      echo "❌ Coverage $coverage% is below 80% threshold"
      exit 1
    fi
```

---

## Local Testing

Test the workflow steps locally before pushing:

```bash
# Run linting
npm run lint

# Run type checking
npm run type-check

# Run tests
npm test

# Run verification script
./src/scripts/verify-task.sh

# Check for anti-patterns
grep -r "console\.log" src/ --include="*.ts"
```

---

## Understanding Workflow Status

### All Green ✅
- All checks passed
- Code is ready to merge
- Quality gates satisfied

### Security Failed 🔐
- Potential secrets detected in code
- `.env` file tracked in git
- **Action:** Remove secrets, use environment variables

### Verify Failed ❌
- Tests failing
- Linting errors
- Type errors
- Anti-patterns detected
- **Action:** Fix issues before merging

### Quality Warning ⚠️
- Unused dependencies
- Large bundle size
- **Action:** Consider cleaning up, but not blocking

---

## Disabling Specific Checks

If a check doesn't apply to your project, you can:

### 1. Skip Entire Job
```yaml
quality:
  if: false  # Disable this job
```

### 2. Make Check Non-Blocking
```yaml
- name: Some check
  run: some-command
  continue-on-error: true  # Don't fail if this step fails
```

### 3. Conditional Execution
```yaml
- name: Node-specific check
  if: hashFiles('package.json') != ''
  run: npm run check
```

---

## Adding More Workflows

### Code Coverage Upload

```yaml
name: Coverage

on: [push, pull_request]

jobs:
  coverage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm run test:coverage
      - uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
```

### Automated Dependency Updates

```yaml
name: Dependency Updates

on:
  schedule:
    - cron: '0 0 * * 1'  # Weekly on Monday

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm update
      - uses: peter-evans/create-pull-request@v5
        with:
          commit-message: 'chore: update dependencies'
          title: 'Weekly Dependency Update'
```

---

## Troubleshooting

### Workflow Not Running

**Problem:** Workflow doesn't trigger on push
**Solution:** Check branch names match (main vs master)

### Permission Errors

**Problem:** Script permission denied
**Solution:** Add `chmod +x` before running scripts:
```yaml
- run: chmod +x ./scripts/verify-task.sh && ./scripts/verify-task.sh
```

### Cache Issues

**Problem:** Old dependencies cached
**Solution:** Clear cache in GitHub repo settings or change cache key

### Timeout Issues

**Problem:** Workflow times out
**Solution:** Add timeout:
```yaml
jobs:
  verify:
    timeout-minutes: 10
```

---

## Best Practices

1. **Keep workflows fast** - Under 5 minutes ideal
2. **Fail fast** - Put quick checks first
3. **Use caching** - Cache dependencies for speed
4. **Don't duplicate** - Reuse steps with composite actions
5. **Document custom checks** - Explain why each check exists

---

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Starter Workflows](https://github.com/actions/starter-workflows)
