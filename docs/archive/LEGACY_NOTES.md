# Legacy Notes

> **⚠️ ARCHIVED DOCUMENT**
>
> This is historical documentation and should NOT be followed unless explicitly instructed.
> This file is kept for reference only and does not represent current guidance.

## Purpose

This document identifies high-risk or legacy areas of the codebase that require special caution.

---

## Legacy Systems

*As the project evolves, document legacy areas here that require careful handling*

---

## Example Entry Format

### Module: [Legacy Module Name]

**Status**: Legacy / Deprecated / Pending Migration

**Description**: *[What this module does]*

**Why It Exists**: *[Historical context]*

**Known Issues**:
- *[Issue 1]*
- *[Issue 2]*

**Caution Areas**:
- *[What to be careful about when modifying]*
- *[Side effects or dependencies to watch]*

**Migration Plan**: *[If applicable, plan to modernize or remove]*

**Dependencies**:
- *[What depends on this]*
- *[What this depends on]*

**Last Modified**: *[Date and reason]*

---

## High-Risk Areas

### Area: [Component/Module Name]

**Why High-Risk**: *[Why this needs extra care]*

**Gotchas**:
- *[Common mistakes or traps]*
- *[Unexpected behaviors]*

**Testing Requirements**: *[Extra testing needed when touching this]*

---

## Technical Debt

### Debt Item 1: [Description]

**Impact**: High | Medium | Low

**Description**: *[What the debt is]*

**Why It Exists**: *[Why it was done this way]*

**Cost of Maintaining**: *[What it costs us to keep it]*

**Cost of Fixing**: *[What it would take to fix]*

**Recommendation**: *[Should we fix it or leave it?]*

---

## Deprecated Features

### Feature: [Feature Name]

**Deprecated Date**: *[When it was deprecated]*

**Reason**: *[Why it was deprecated]*

**Replacement**: *[What to use instead]*

**Removal Date**: *[When it will be removed]*

**Migration Guide**: *[How to migrate away from it]*
