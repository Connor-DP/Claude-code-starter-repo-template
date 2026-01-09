# Anti-Patterns

## Purpose

This document explicitly lists things we DO NOT do in this codebase. These are prohibited designs, patterns, and practices.

---

## Architectural Anti-Patterns

### ❌ God Objects
**Don't**: Create classes or modules that know too much or do too much

**Why**: Violates single responsibility, hard to test and maintain

**Instead**: Break into focused, single-purpose modules

---

### ❌ Callback Hell / Pyramid of Doom
**Don't**: Nest callbacks more than 2-3 levels deep

**Why**: Unreadable, hard to debug, error handling becomes complex

**Instead**: Use async/await or promise chains

```javascript
// BAD
getData(function(a) {
  getMoreData(a, function(b) {
    getMoreData(b, function(c) {
      // ...
    });
  });
});

// GOOD
const a = await getData();
const b = await getMoreData(a);
const c = await getMoreData(b);
```

---

### ❌ Magic Numbers / Strings
**Don't**: Use unexplained literal values in code

**Why**: Meaning is unclear, hard to maintain, easy to make mistakes

**Instead**: Use named constants with clear intent

```javascript
// BAD
if (user.age > 18) { ... }

// GOOD
const LEGAL_ADULT_AGE = 18;
if (user.age > LEGAL_ADULT_AGE) { ... }
```

---

## Code Anti-Patterns

### ❌ Copy-Paste Code
**Don't**: Duplicate code instead of abstracting

**Why**: Changes must be made in multiple places, bugs get duplicated

**Instead**: Extract to reusable functions/modules (but don't over-abstract)

---

### ❌ Ignoring Errors Silently
**Don't**: Catch errors and do nothing

**Why**: Hides bugs, makes debugging impossible

**Instead**: Log errors, handle appropriately, or let them bubble up

```javascript
// BAD
try {
  riskyOperation();
} catch (e) {
  // Do nothing
}

// GOOD
try {
  riskyOperation();
} catch (e) {
  logger.error('Operation failed', e);
  throw new AppError('Failed to complete operation', e);
}
```

---

### ❌ Boolean Parameters
**Don't**: Use boolean flags to control function behavior

**Why**: Unclear what `true`/`false` means at call site

**Instead**: Use separate functions or options object

```javascript
// BAD
sendEmail(user, true, false);

// GOOD
sendEmail(user, { urgent: true, ccAdmin: false });
```

---

## Security Anti-Patterns

### ❌ Storing Secrets in Code
**Don't**: Hardcode API keys, passwords, tokens

**Why**: Security risk, leaked in version control

**Instead**: Use environment variables and secret management

---

### ❌ Building SQL from Strings
**Don't**: Concatenate SQL queries with user input

**Why**: SQL injection vulnerability

**Instead**: Use parameterized queries or ORM

```javascript
// BAD
const query = `SELECT * FROM users WHERE id = ${userId}`;

// GOOD
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);
```

---

### ❌ Client-Side Authorization Only
**Don't**: Rely only on frontend checks for permissions

**Why**: Easily bypassed, security through obscurity

**Instead**: Always validate on the server

---

## Testing Anti-Patterns

### ❌ Testing Implementation Details
**Don't**: Test internal state or private methods

**Why**: Brittle tests that break on refactoring

**Instead**: Test public interfaces and behavior

---

### ❌ One Assertion to Rule Them All
**Don't**: Test multiple unrelated things in one test

**Why**: Unclear what failed, hard to debug

**Instead**: One concept per test, clear test names

---

### ❌ Test Interdependence
**Don't**: Make tests depend on running in specific order

**Why**: Flaky tests, hard to debug, slow test suite

**Instead**: Each test should be independent and isolated

---

## Performance Anti-Patterns

### ❌ N+1 Queries
**Don't**: Query in a loop when you could fetch all at once

**Why**: Massive performance hit with large datasets

**Instead**: Batch queries or use joins

---

### ❌ Premature Optimization
**Don't**: Optimize before measuring performance

**Why**: Wastes time, adds complexity unnecessarily

**Instead**: Measure first, optimize bottlenecks

---

### ❌ Blocking the Event Loop
**Don't**: Perform heavy computation or synchronous I/O on main thread

**Why**: Freezes application, poor user experience

**Instead**: Use workers, async operations, or streaming

---

## State Management Anti-Patterns

### ❌ Prop Drilling
**Don't**: Pass props through many layers just to reach deep components

**Why**: Couples components, hard to maintain

**Instead**: Use context, state management, or composition

---

### ❌ Mutating State Directly
**Don't**: Modify state objects in place

**Why**: Breaks change detection, causes bugs

**Instead**: Create new objects/arrays (immutable updates)

---

## Documentation Anti-Patterns

### ❌ Commenting What Instead of Why
**Don't**: Write comments that just restate the code

**Why**: Adds noise without value

**Instead**: Explain WHY, not what (code shows what)

```javascript
// BAD
// Increment counter by 1
counter = counter + 1;

// GOOD
// Skip the first item as it's the header row
counter = counter + 1;
```

---

### ❌ Outdated Documentation
**Don't**: Leave old docs that don't match current code

**Why**: Misleading, worse than no docs

**Instead**: Update docs with code changes or delete them

---

## Project-Specific Anti-Patterns

*Add anti-patterns specific to this project as they're discovered*

### ❌ [Pattern Name]
**Don't**: *[What not to do]*

**Why**: *[Why it's bad in this project]*

**Instead**: *[The correct approach]*
