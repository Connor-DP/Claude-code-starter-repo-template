# Tests Directory

## Purpose

This directory contains all test files for the project. This is the canonical location for tests in this template repository.

---

## Template Repository Note

**This is a template repository** designed to be cloned and customized for new projects. When using this template:

### For AI Agents (Claude, etc.)

When working in a project based on this template:
1. **Always place tests here** (`/tests/`) unless the project uses a different convention (e.g., `src/**/__tests__/`)
2. **Check for existing test structure first** before creating new test files
3. **Follow the testing framework** already established in the project
4. **Never invent test locations** - if unclear, ask the user

### For Human Developers

When starting a new project from this template:
1. Choose your testing approach:
   - **Option A**: Keep tests here (`/tests/`)
   - **Option B**: Co-locate tests with source (`src/**/__tests__/`)
   - **Option C**: Other convention (update this README)

2. Update this README with your chosen approach
3. Configure your test runner accordingly
4. Add test framework dependencies to package.json

---

## Test Structure

Organize tests to mirror your source structure:

```
tests/
├─ unit/
│  ├─ components/
│  ├─ utils/
│  └─ services/
├─ integration/
│  └─ api/
├─ e2e/
│  └─ user-flows/
└─ fixtures/
   └─ test-data.json
```

## Running Tests

```bash
# Run all tests
npm test

# Run specific test suite
npm test -- unit

# Run with coverage
npm test -- --coverage

# Watch mode
npm test -- --watch
```

## Test Conventions

### Naming
- Test files: `*.test.ts` or `*.spec.ts`
- Mirror source file structure
- Descriptive test names: `should handle edge case when X`

### Organization
```typescript
describe('ComponentName', () => {
  describe('methodName', () => {
    it('should do expected behavior', () => {
      // Arrange
      // Act
      // Assert
    });
  });
});
```

### Best Practices
- **Arrange-Act-Assert**: Structure tests clearly
- **One assertion per test**: Keep tests focused
- **Descriptive names**: Test name should explain the scenario
- **Test behavior, not implementation**: Focus on outputs, not internals
- **Use fixtures**: Shared test data in `/fixtures/`

## Test Coverage Goals

Define your coverage targets (example):
- **Statements**: 80%
- **Branches**: 75%
- **Functions**: 80%
- **Lines**: 80%

## Common Test Utilities

Document shared test utilities, mocks, and helpers:

```typescript
// tests/utils/test-helpers.ts
export const createMockUser = () => ({ ... });
export const mockApiResponse = (data) => ({ ... });
```

## CI/CD Integration

Tests should run automatically:
- On every push
- Before merging PRs
- Before deployment

See `.github/workflows/` for CI configuration.

---

## Framework-Specific Notes

### Jest
```json
// jest.config.js
{
  "testMatch": ["**/tests/**/*.test.ts"],
  "collectCoverageFrom": ["src/**/*.ts"]
}
```

### Vitest
```typescript
// vitest.config.ts
export default {
  test: {
    include: ['tests/**/*.test.ts']
  }
}
```

### Pytest (Python)
```python
# tests/conftest.py
# Shared fixtures here
```

---

**Template Repository Reminder**: This README is intentionally verbose to help AI agents understand testing conventions when working in projects derived from this template. Customize it for your specific project needs.
