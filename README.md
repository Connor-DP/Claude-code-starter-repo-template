# AI-Assisted Development Template

> **A production-ready template for building software with Claude (or any AI coding assistant)**

This repository provides a constitutional framework for AI-assisted development. It's designed for **Product Owners, non-technical founders, and developers** who want structured, high-quality AI collaboration.

**Stop fighting with context loss. Start building with confidence.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

---

> **📋 Note on README files:**
> - **`README.md`** (this file) - Explains the template itself (for GitHub visitors)
> - **`README_PROJECT.md`** - Template for your project's README (replace this file with that when you start your project)

---

## 🎯 The Problem This Solves

When building with AI coding assistants, you hit these issues:

- ❌ **Where do I put things?** No clear structure = chaos
- ❌ **AI loses context** between conversations
- ❌ **Multiple tasks blur together** causing confusion
- ❌ **No quality gates** - how do you know when something is "done"?
- ❌ **Expensive token usage** from re-reading heavy docs every turn
- ❌ **Hard to hand off** to real developers later

**This template solves all of these.**

---

## ✨ What You Get

### 1. **Constitutional Framework**
A clear hierarchy of documents that AI agents understand:
- **Requirements** (PRD, TECH_SPEC) - what to build
- **Active State** (root directory) - what's being built now
- **Context** (NOTES.md) - exploratory, not requirements
- **History** (archive/) - completed work

### 2. **Root-Based Active State**
- `IMPLEMENTATION_PLAN.md` in root = current task
- Only one active task at a time (enforced)
- Completed tasks automatically archived
- Clear state machine: root = active, archive = done

### 3. **Automated Task Lifecycle**
```bash
./src/scripts/task.sh start "feature-name"   # Start working
# ... AI builds the feature ...
./src/scripts/task.sh finish "feature-name"  # Archive when done
```

### 4. **Token Optimization**
- **40-50% cost reduction** on long conversations
- Priority files sent every turn (4 essential state files)
- Heavy docs read once, kept in context history
- Archived tasks ignored completely

### 5. **Quality Gates Built-In**
- Verification script must pass before archival
- Comprehensive checklists for every phase
- Test requirements enforced
- Security checks included

### 6. **Production-Ready Documentation**
Every directory has a README. Every concept is explained. No guesswork.

---

## 🚀 Quick Start

### For Product Owners (No Coding Required)

1. **Clone this repository:**
   ```bash
   git clone https://github.com/YOUR-USERNAME/ai-dev-template.git my-project
   cd my-project
   ```

2. **Customize for your project:**
   - Replace `README.md` with `README_PROJECT.md` (rename it)
   - Edit `docs/PRD.md` - describe what you're building
   - Edit `docs/APP_FLOW.md` - describe user journeys
   - Edit `.claude/settings.json` - update tech stack

3. **Start your first task:**
   ```bash
   ./src/scripts/task.sh start "initial-setup"
   ```

4. **Edit `IMPLEMENTATION_PLAN.md`** with what you want:
   ```markdown
   ## Acceptance Criteria
   - [ ] Users can sign up with email
   - [ ] Users receive confirmation email
   - [ ] Users can log in
   ```

5. **Tell Claude:**
   > "Please implement this according to the plan in IMPLEMENTATION_PLAN.md"

6. **Track progress** in `CHECKLIST.md`

7. **When done:**
   ```bash
   ./src/scripts/task.sh finish "initial-setup"
   ```

That's it! Repeat for each feature.

---

## 💬 Starter Prompts for Claude

**New to AI-assisted development?** Use these prompts to get Claude to help you set up your project:

### Discovery Session (Start Here if You're Unsure)

```
I have an idea for a project but I'm not sure how to structure it or what to tell you.

**My rough idea:**
[Describe your idea in a few sentences - even vague is fine]

Please ask me questions to help me define:
1. What problem I'm trying to solve
2. Who the users are
3. What the core features should be
4. What tech stack makes sense
5. What my MVP should look like

Then help me create a clear PRD and project structure.
```

### Initial Setup

```
I've cloned the AI-assisted development template. Help me set it up for my project:

**My Project:**
- Name: [Your project name]
- Purpose: [What problem does it solve?]
- Users: [Who will use it?]
- Tech Stack: [Python/TypeScript/etc.]

Please help me:
1. Update docs/PRD.md with my project vision
2. Update docs/TECH_SPEC.md with my tech stack
3. Update .claude/settings.json for my environment
4. Create a basic docs/APP_FLOW.md with key user journeys
```

### Defining Your First Feature

```
I want to add [feature name] to my project.

**What it should do:**
- [Describe the feature in plain English]
- [What should users be able to do?]
- [What's the expected outcome?]

Please help me:
1. Start a new task with ./src/scripts/task.sh start "[feature-name]"
2. Create a detailed IMPLEMENTATION_PLAN.md with:
   - Clear acceptance criteria
   - Implementation approach
   - Testing strategy
   - Any risks or considerations
```

### When You're Stuck

```
I'm looking at [file/feature] and I'm not sure:
- [What you're confused about]
- [What you're trying to achieve]

Please help me understand:
1. How this fits into the overall architecture
2. What the best approach would be
3. Any anti-patterns I should avoid (check docs/ANTI_PATTERNS.md)
```

### Asking for Architecture Guidance

```
I need to make an architectural decision about [topic].

**Context:**
- [What are you trying to build?]
- [What are the constraints?]

**Options I'm considering:**
1. [Option 1]
2. [Option 2]

Please consult .claude/agents/ARCHITECT.md and help me:
1. Evaluate the trade-offs
2. Recommend an approach
3. Create an ADR in docs/adr/ documenting the decision
```

### Quality Check Before Finishing

```
I've completed work on [feature]. Before I archive this task, please:

1. Review my CHECKLIST.md - is everything complete?
2. Check if I need to create any ADRs for decisions I made
3. Verify IMPLEMENTATION_PLAN.md reflects what was actually built
4. Run through the verification steps in ai/DEFINITIONS/REVIEW_GUIDE.md
5. Let me know if I'm ready to run ./src/scripts/task.sh finish
```

### Understanding the Workflow

```
I'm new to this template. Please explain:

1. Read CLAUDE.md and explain the workflow in simple terms
2. What files should I focus on as a [Product Owner/Developer]?
3. Walk me through a complete feature cycle from start to finish
4. What are the most common mistakes to avoid?
```

### Getting Unstuck with Tests

```
I need help with tests for [feature].

Please:
1. Check tests/README.md for our test conventions
2. Suggest what tests I should write
3. Help me write the tests following our standards
4. Ensure they follow patterns in docs/ARCHITECTURE.md
```

### Migrating an Existing Project

```
I have an existing project and want to adopt this template structure.

**Current state:**
- Tech stack: [Your current stack]
- Project size: [Small/Medium/Large]
- Main pain points: [What's not working well]

Please help me:
1. Analyze my current structure
2. Create a migration plan to this template
3. Identify what documentation I need to write
4. Suggest how to handle existing code/features
5. Prioritize what to migrate first
```

### Debugging with Context

```
I'm getting [error/unexpected behavior] when [doing what].

**Context:**
- What I'm trying to do: [Goal]
- What's happening: [Actual behavior]
- What I expected: [Expected behavior]
- Relevant files: [List files]

Please:
1. Read the relevant files
2. Check if this violates anything in docs/ANTI_PATTERNS.md
3. Review the approach in my IMPLEMENTATION_PLAN.md
4. Help me debug and fix the issue
5. Suggest tests to prevent this in the future
```

---

## 📁 Structure

```
.
├── README.md                          # You are here
├── CLAUDE.md                          # Constitutional rules (READ THIS FIRST)
├── IMPLEMENTATION_PLAN.md             # ← Current active task (when present)
├── CHECKLIST.md                       # ← Progress tracking
├── NOTES.md                           # ← Scratchpad (not requirements)
│
├── docs/                              # Requirements (stable)
│   ├── PRD.md                         # Product vision (YOU WRITE THIS)
│   ├── TECH_SPEC.md                   # Technical stack
│   ├── ARCHITECTURE.md                # System design
│   ├── APP_FLOW.md                    # User journeys (YOU WRITE THIS)
│   ├── ANTI_PATTERNS.md               # What to avoid
│   ├── adr/                           # Architectural decisions
│   │   └── README.md                  # Decision log index
│   └── archive/                       # Deprecated docs
│
├── ai/                                # AI-specific context
│   ├── CONTEXT.md                     # Reading contract for AI
│   ├── DEFINITIONS/                   # Quality standards
│   │   ├── DONE_DEFINITION.md         # When is something "done"?
│   │   ├── QUALITY_BAR.md             # Code quality standards
│   │   └── REVIEW_GUIDE.md            # Review checklist
│   └── TASKS/
│       └── archive/                   # Completed tasks
│           └── YYYY-MM-DD-task-name/
│
├── tests/                             # All tests live here
│   └── README.md                      # Test conventions
│
├── src/                               # Your application code
│   └── scripts/
│       ├── task.sh                    # Task lifecycle automation
│       └── verify-task.sh             # Quality gate
│
└── .claude/                           # Claude-specific config
    ├── settings.json                  # Context & token optimization
    ├── agents/                        # Specialized personas
    │   ├── ARCHITECT.md
    │   ├── QA_ENGINEER.md
    │   └── TECH_LEAD.md
    ├── commands/                      # Workflow guides
    │   ├── plan.md
    │   ├── implement.md
    │   └── review.md
    └── templates/                     # Task templates
        ├── IMPLEMENTATION_PLAN.md
        ├── CHECKLIST.md
        └── NOTES.md
```

---

## 🎓 How It Works

### The Core Insight

**Active work lives in the root directory.** This makes it:
- Fast for AI to access (no nested paths)
- Token-efficient (priority files always in same location)
- Visually obvious (root files = current work)
- Impossible to have multiple active tasks

### The Workflow

1. **Start task** → Templates copied to root
2. **Define requirements** → Edit IMPLEMENTATION_PLAN.md
3. **AI builds** → Follows plan, updates CHECKLIST.md
4. **You verify** → Check it works
5. **Archive** → Files moved to ai/TASKS/archive/

### Document Hierarchy

AI agents read in this order:

**Authoritative (requirements):**
1. `CLAUDE.md` - Constitutional rules
2. `IMPLEMENTATION_PLAN.md` - Current task
3. `docs/PRD.md` - Product vision
4. `docs/TECH_SPEC.md` - Technical details
5. `docs/ANTI_PATTERNS.md` - Constraints

**Context (not requirements):**
- `CHECKLIST.md` - Progress tracker
- `NOTES.md` - Scratchpad
- `ai/TASKS/archive/` - History

---

## 💡 Use Cases

### For Product Owners
Define what you want in plain English. Claude builds it following professional standards.

**Your workflow:**
1. Write `docs/PRD.md` - what problem are we solving?
2. Write `docs/APP_FLOW.md` - how do users interact?
3. For each feature:
   - Start task
   - Define acceptance criteria
   - Let Claude build
   - Verify and archive

### For Solo Founders
Build your MVP without hiring a dev team. Keep code quality high for when you do hire.

**You get:**
- Professional code structure
- Automated testing
- Clear documentation
- Decision history (ADRs)
- Easy handoff to developers

### For Developers
A framework that keeps AI assistants on track and enforces quality standards.

**You get:**
- Consistent AI behavior
- Token cost optimization
- Quality gates
- Clear task management
- No context loss

---

## 🔧 Customization

### 1. Update for Your Tech Stack

Edit `.claude/settings.json`:
```json
{
  "environment": {
    "language": "Python",          // Change to your language
    "runtime": "Django",            // Change to your framework
    "packageManager": "pip",        // Change to your package manager
    "testFramework": "pytest"       // Change to your test framework
  }
}
```

### 2. Define Your Product

Edit `docs/PRD.md`:
```markdown
# Product Requirements

## Problem
Describe the problem you're solving

## Solution
Describe your solution

## Key Features
1. Feature 1
2. Feature 2
```

### 3. Customize Templates

Edit files in `.claude/templates/` to match your workflow.

---

## 📚 Key Documents

| Document | Purpose | Who Writes It |
|----------|---------|---------------|
| `CLAUDE.md` | Constitutional rules | Template (rarely change) |
| `docs/PRD.md` | Product vision | **You (Product Owner)** |
| `docs/APP_FLOW.md` | User journeys | **You (Product Owner)** |
| `docs/TECH_SPEC.md` | Technical stack | You or AI |
| `IMPLEMENTATION_PLAN.md` | Current task | You + AI |
| `docs/ANTI_PATTERNS.md` | Code quality rules | You or AI |

---

## 🤝 Contributing

Found this useful? Here's how to help:

1. ⭐ **Star the repo** to help others find it
2. 🐛 **Report issues** you encounter
3. 💡 **Share improvements** via PRs
4. 📢 **Tell others** who are building with AI

---

## 📖 Philosophy

This template is based on these principles:

1. **Single Source of Truth** - Clear document hierarchy
2. **State Machine Discipline** - One task at a time
3. **Completion Rigor** - Quality gates before "done"
4. **Decision Transparency** - Document architectural choices
5. **Token Efficiency** - Read heavy docs once, not every turn

---

## 🎯 What This Is NOT

- ❌ Not a framework or library
- ❌ Not language-specific
- ❌ Not a code generator
- ❌ Not magic

**It's a structure.** A way to organize your codebase so AI assistants can work effectively without constant re-explanation.

---

## 🚦 Getting Help

1. **Read `CLAUDE.md` first** - explains the entire system
2. **Check `ai/CONTEXT.md`** - explains document hierarchy
3. **Look at `.claude/commands/`** - workflow guides
4. **Open an issue** - we're here to help

---

## 📄 License

MIT License - use this however you want. No attribution required.

---

## 🙏 Credits

Built by a Product Owner who got tired of fighting with AI context loss.

Refined through real projects, real mistakes, and real lessons learned.

---

## ⚡ Quick Commands Reference

```bash
# Task lifecycle
./src/scripts/task.sh start "task-name"      # Start new task
./src/scripts/task.sh finish "task-name"     # Archive completed task
./src/scripts/task.sh list                   # Show active/archived tasks

# Verification
./src/scripts/verify-task.sh                 # Verify task completion
```

---

**Ready to build with AI? Clone this repo and start shipping.** 🚀
