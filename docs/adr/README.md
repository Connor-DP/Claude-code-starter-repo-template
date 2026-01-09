# Architecture Decision Records (ADR)

## Purpose

This directory contains Architecture Decision Records (ADRs) - documents that capture important architectural decisions made along with their context and consequences.

## What is an ADR?

An ADR is a document that captures an important architectural decision made along with its context and consequences. ADRs help:
- Prevent re-litigation of decisions
- Provide historical context for future team members
- Document the "why" behind architectural choices
- Track the evolution of the system

## Format

Each ADR follows this structure:
- **Status**: Proposed | Accepted | Deprecated | Superseded
- **Context**: What is the issue motivating this decision?
- **Decision**: What is the change we're proposing/making?
- **Consequences**: What becomes easier or more difficult?

## Naming Convention

ADRs are numbered sequentially:
```
0001-<descriptive-title>.md
0002-<descriptive-title>.md
0003-<descriptive-title>.md
```

## Creating a New ADR

1. Copy the template from `0001-example-decision.md`
2. Number it sequentially (check existing ADRs)
3. Give it a descriptive slug-based title
4. Fill in all sections
5. Update this index below

## ADR Index

| Number | Title | Status | Date |
|--------|-------|--------|------|
| [0001](./0001-example-decision.md) | Example Decision Template | Example | - |

---

## Quick Reference Guide

### When to Write an ADR

Write an ADR when you:
- Choose between multiple viable architectural approaches
- Make a decision that affects system structure or patterns
- Establish a convention or standard
- Make a choice with significant long-term implications
- Change or reverse a previous architectural decision

### When NOT to Write an ADR

Skip the ADR for:
- Implementation details within an established pattern
- Routine bug fixes
- Small refactorings that don't change structure
- Decisions that are easily reversible
- Obvious choices with no alternatives

### Example Decision Types

**Good ADR candidates:**
- Choice of state management library (Redux vs Context vs Zustand)
- Database selection and schema approach
- Authentication/authorization strategy
- API design patterns (REST vs GraphQL)
- Deployment architecture
- Testing strategy and framework choices
- Monorepo vs multi-repo structure

**Not ADR-worthy:**
- Variable naming conventions
- Specific component implementations
- Bug fix approaches
- Code formatting rules (use linter config instead)
