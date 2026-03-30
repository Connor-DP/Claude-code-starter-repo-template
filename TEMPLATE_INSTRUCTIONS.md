# 🏁 Setting Up Your Repository

> **READ ME FIRST**: This file guides you through setting up this template for your specific project. Once you're done, you can delete this file.

---

## ⏱️ The First 30 Minutes

### 1. Run the Doctor

Check if your environment is ready:

```bash
# Make scripts executable
chmod +x src/scripts/*.sh

# Run environment check
./src/scripts/doctor.sh
```

Fix any errors (install Node/Python, configure git, etc.) before proceeding.

---

### 2. Configure Your Stack

Open [.claude/settings.json](.claude/settings.json) and update the `commands` section:

#### For Node.js/TypeScript (Default)
No changes needed! Already configured.

#### For Python
```json
{
  "commands": {
    "test": "pytest",
    "lint": "ruff check .",
    "typecheck": "mypy .",
    "build": "python -m build",
    "format": "ruff format --check ."
  },
  "verification": {
    "srcDir": "src"
  }
}
```

#### For Go
```json
{
  "commands": {
    "test": "go test ./...",
    "lint": "golangci-lint run",
    "typecheck": "go vet ./...",
    "build": "go build ./...",
    "format": "gofmt -l ."
  },
  "verification": {
    "srcDir": "."
  }
}
```

#### For Rust
```json
{
  "commands": {
    "test": "cargo test",
    "lint": "cargo clippy",
    "typecheck": "cargo check",
    "build": "cargo build",
    "format": "cargo fmt -- --check"
  },
  "verification": {
    "srcDir": "src"
  }
}
```

**Note:** See `.claude/settings.json` → `examples` section for these ready-to-copy configs.

---

### 3. Define Your Project

The AI needs context to work effectively. Fill in these files (they have instructional comments inside):

1. **[docs/PRD.md](docs/PRD.md)** - What are you building?
   - Product vision and goals
   - Target users
   - Core features (MVP)

2. **[docs/TECH_SPEC.md](docs/TECH_SPEC.md)** - How are you building it?
   - Technology stack
   - Architecture overview
   - Data models and APIs

3. **[docs/APP_FLOW.md](docs/APP_FLOW.md)** - How does it work?
   - User journeys
   - Key interactions
   - State flows

**Tip:** Ask Claude to help! Say:
```
Help me fill out the PRD based on my idea: [describe your project in 2-3 sentences]
```

---

### 4. Initialize Git

```bash
git init
git add .
git commit -m "Initial commit from AI template"
```

**Note:** The first time you run `./src/scripts/task.sh start`, it will auto-install a git pre-commit hook for quality checks.

---

### 5. Start Your First Task

```bash
./src/scripts/task.sh start "project-setup"
```

Then use the agent-powered workflow:
```
/plan
```

This spawns `@scout` to explore the codebase and `@architect` to design the approach.
Then run `/implement` to build and `/review` to verify.

Or for a quick start, ask Claude directly:
```
Read IMPLEMENTATION_PLAN.md and help me set up the basic file structure
and a "Hello World" endpoint. Use @scout to find existing patterns.
```

---

### 6. Meet the Agents

Your project comes with 7 specialized AI agents. Use them by name:

| Agent | When to use | Example |
|-------|-------------|---------|
| `@scout` | Find code, understand patterns | "Use @scout to find how auth works" |
| `@architect` | Design decisions, trade-offs | "Ask @architect to design the DB schema" |
| `@implementer` | Build features (runs in worktree) | "Have @implementer build the user API" |
| `@reviewer` | Code review | "Ask @reviewer to check my changes" |
| `@qa` | Find bugs, test coverage | "Have @qa test the payment flow" |
| `@security-auditor` | Security scan | "Run @security-auditor before the PR" |
| `@doc-writer` | Documentation, ADRs | "Ask @doc-writer to create an ADR" |

`@scout` runs on a cheaper model (Haiku) — use it constantly for codebase questions instead of searching manually.

---

## 🧹 Cleanup Checklist

Before you start coding properly, clean up the template artifacts:

### Required Cleanup
- [ ] Update [README.md](README.md) with your project name and description
- [ ] Fill in [docs/PRD.md](docs/PRD.md) with your product vision
- [ ] Fill in [docs/TECH_SPEC.md](docs/TECH_SPEC.md) with your tech stack
- [ ] Fill in [docs/APP_FLOW.md](docs/APP_FLOW.md) with your user flows
- [ ] Update [.claude/settings.json](.claude/settings.json) if not using Node.js/TypeScript

### Optional Cleanup
- [ ] Delete [ai/TASKS/archive/2026-01-10-add-user-authentication/](ai/TASKS/archive/2026-01-10-add-user-authentication/) (it's just an example)
- [ ] Delete [docs/adr/0002-jwt-authentication.md](docs/adr/0002-jwt-authentication.md) (example ADR)
- [ ] Update [docs/adr/README.md](docs/adr/README.md) to remove example entry
- [ ] Delete this file (`TEMPLATE_INSTRUCTIONS.md`) once setup is complete

---

## 🚀 Quick Start Examples

### For Solo Founders (No Coding Background)

**Goal:** Build an MVP with Claude's help

1. **Fill out PRD** (in plain English):
   ```
   Claude, I want to build a tool that helps freelancers track their time and generate invoices.
   Help me fill out docs/PRD.md with proper structure.
   ```

2. **Define stack** (let Claude help):
   ```
   Claude, what tech stack would you recommend for my project?
   I want something simple that I can deploy easily.
   Update docs/TECH_SPEC.md and .claude/settings.json for me.
   ```

3. **Start building**:
   ```bash
   ./src/scripts/task.sh start "user-authentication"
   ```

   Then say:
   ```
   Claude, implement user authentication with email/password.
   Follow the implementation plan template.
   ```

### For Developers (Technical Background)

**Goal:** Use AI to accelerate development while maintaining quality

1. **Configure immediately:**
   - Update `.claude/settings.json` with your exact stack
   - Fill in `docs/TECH_SPEC.md` with your architecture decisions
   - Add any project-specific anti-patterns to `docs/ANTI_PATTERNS.md`

2. **Use the workflow:**
   ```bash
   ./src/scripts/task.sh start "api-endpoint-users"
   ```

   Use `/plan`, `/implement`, `/review` commands with Claude for systematic development.

3. **Customize verification:**
   - Edit `src/scripts/verify-task.sh` if you need custom checks
   - Update `.github/workflows/verify-task.yml` for your CI/CD needs

---

## 📚 Key Concepts

### The Root Directory = Active Task
- When `IMPLEMENTATION_PLAN.md` exists in root, that's THE active task
- Only one task at a time (enforced by scripts)
- When done, files move to `ai/TASKS/archive/YYYY-MM-DD-task-name/`

### The Workflow
```
./src/scripts/task.sh start "feature-name"
→ Edit IMPLEMENTATION_PLAN.md (what to build)
→ /plan (create detailed plan with Claude)
→ /implement (build it systematically)
→ /review (verify quality)
→ ./src/scripts/task.sh finish "feature-name"
```

### Commands & Agents
- **`/plan`** — Spawns `@scout` + `@architect` to design
- **`/implement`** — Uses `@scout` + `@implementer` to build
- **`/review`** — Runs `@reviewer` + `@qa` + `@security-auditor` in parallel
- **`/migrate`** — Refactor legacy code to current standards

See [.claude/commands/README.md](.claude/commands/README.md) for details.

---

## 🆘 Troubleshooting

### "doctor.sh says command not found"
```bash
chmod +x src/scripts/doctor.sh
./src/scripts/doctor.sh
```

### "verify-task.sh fails with 'npm: command not found'"
You need to update `.claude/settings.json` → `commands` section for your stack (Python, Go, etc.).

### "Claude doesn't follow my implementation plan"
Make sure `IMPLEMENTATION_PLAN.md` is in the **root directory**, not nested in a folder.

### "I want to skip the formal workflow for quick fixes"
That's fine! The workflow is for non-trivial features. For typos or one-liners, just edit and commit.

This is called **"Lite Mode"** in the system - see [CLAUDE.md](CLAUDE.md) → Workflow → Lite Mode for details.

### "How do I work on multiple features?"
You don't - not simultaneously. Finish one task, archive it, then start the next. This prevents context mixing.

For urgent changes: archive current task, start "hotfix" task, finish hotfix, resume original.

---

## 🎯 Next Steps

1. ✅ Run `./src/scripts/doctor.sh`
2. ✅ Update `.claude/settings.json` for your stack
3. ✅ Fill in `docs/PRD.md`, `docs/TECH_SPEC.md`, `docs/APP_FLOW.md`
4. ✅ Run `./src/scripts/task.sh start "your-first-task"`
5. ✅ Ask Claude to help you implement!

---

## 📖 Further Reading

- [CLAUDE.md](CLAUDE.md) - The constitutional rules (read this to understand the full system)
- [README.md](README.md) - Complete template documentation
- [ai/CONTEXT.md](ai/CONTEXT.md) - Document hierarchy and reading order
- [.claude/commands/README.md](.claude/commands/README.md) - Command reference

---

**Ready to build?** Delete this file when you're all set up, and start shipping! 🚀
