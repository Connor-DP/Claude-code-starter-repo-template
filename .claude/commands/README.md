# Claude Commands

## Purpose
These commands provide standardized, agent-powered workflows for AI-assisted development. Each command orchestrates specialized subagents to handle different aspects of the work.

## Available Commands

### `/plan` - Create Implementation Plan
Design and plan before building. Spawns `@scout` for codebase exploration and `@architect` for system design.

**When to use:** Starting any non-trivial work — features, refactors, multi-file bug fixes.

**Agents used:** `@scout` (find patterns), `@architect` (design solution)

**Output:** `IMPLEMENTATION_PLAN.md`, `CHECKLIST.md`, `NOTES.md` in root

---

### `/implement` - Execute Implementation
Build the plan using agents for coding and quality. Uses `@scout` for codebase questions, `@implementer` for isolated coding, and `@architect` for design questions that arise.

**When to use:** After `/plan` has created a reviewed implementation plan.

**Agents used:** `@scout` (explore), `@implementer` (code in worktree), `@architect` (design questions), `@doc-writer` (ADRs)

**Output:** Working code, tests, updated documentation

---

### `/review` - Verify Completion
Comprehensive quality gate using three agents in parallel. All review agents are read-only — they find problems but cannot modify code.

**When to use:** After implementation, before PR or archive.

**Agents used (in parallel):**
- `@reviewer` — code quality, scope discipline, completion criteria
- `@qa` — test coverage, bug finding, edge cases
- `@security-auditor` — OWASP, secrets, dependency vulnerabilities

**Output:** Three independent reports, clear pass/fail verdict

---

### `/migrate` - Refactor Legacy Code
Migrate legacy code to current architectural standards.

**When to use:**
- Refactoring old code to new patterns
- Removing anti-patterns from existing code
- Updating code to match ARCHITECTURE.md
- Bringing legacy modules up to quality standards

**Output:** Modernized code following current standards

**Read:** [migrate.md](./migrate.md)

---

## Agent-Powered Workflow

### New Feature Development
```
/plan                    /implement                /review
┌──────────────┐        ┌──────────────┐         ┌──────────────────┐
│ @scout       │───────▶│ @scout       │────────▶│ @reviewer        │
│ @architect   │        │ @implementer │         │ @qa              │ (parallel)
│              │        │ @architect   │         │ @security-auditor│
│              │        │ @doc-writer  │         │ @doc-writer      │
└──────────────┘        └──────────────┘         └──────────────────┘
```

### Iterative Development
```
/plan → /implement → /review (issues found) → /implement → /review → archive
```

### Legacy Code Migration
```
/migrate → /plan (migration strategy) → /implement → /review → archive
```

## Key Design Decisions

1. **Agents enforce roles via tool restrictions** — reviewers literally cannot edit code
2. **`@scout` is cheap (Haiku)** — use it constantly for codebase questions
3. **`@implementer` uses git worktrees** — isolated development, safe to experiment
4. **Review agents run in parallel** — three independent assessments simultaneously
5. **Agents have project memory** — they learn your patterns across sessions

## Customization

These commands are templates. Customize them for your project:
- Add project-specific verification steps
- Adjust which agents are spawned
- Add domain-specific agents in `.claude/agents/`
- Modify tool restrictions per your security requirements

## Integration with CLAUDE.md

These commands implement the workflows defined in `/CLAUDE.md`. They are subordinate to constitutional rules but provide detailed procedures for common scenarios.

## Future Commands

Consider adding for your project:
- `/debug` - Debugging workflow
- `/deploy` - Deployment checklist
- `/document` - Documentation generation
- `/performance` - Performance optimization workflow

---

**Note:** These are workflow guides, not executable scripts. AI agents should follow them step-by-step, and humans can use them as checklists.
