# Example Archived Task: Add User Authentication

**This is a reference example showing what a completed task looks like.**

## What This Example Demonstrates

This archived task shows the complete lifecycle of implementing a feature using this template:

### 1. Planning ([IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md))
- Clear objective and acceptance criteria
- Detailed implementation approach broken into phases
- Risk assessment and mitigation strategies
- Testing strategy defined upfront
- Dependencies identified
- Success metrics established

**Key Takeaways:**
- The plan is comprehensive but not overly detailed
- Acceptance criteria are specific and testable
- Risks are identified early with mitigation plans
- The plan evolved during implementation (see "Completion Notes")

### 2. Progress Tracking ([CHECKLIST.md](CHECKLIST.md))
- Granular checklist covering all phases
- Planning → Implementation → Testing → Documentation → Deployment
- Security and code quality checks included
- Final verification before archival

**Key Takeaways:**
- Every checkbox represents an actionable item
- Organized by phase for clarity
- Security and quality are explicit requirements, not afterthoughts
- Nothing is skipped - every item is checked

### 3. Exploratory Context ([NOTES.md](NOTES.md))
- Research and decision-making process documented
- Alternatives considered (sessions vs JWT vs OAuth)
- Implementation discoveries and pivots
- Performance observations
- Questions that came up during work

**Key Takeaways:**
- Notes are NOT requirements (see header warning)
- Shows the thinking process, not just the outcome
- Documents why certain approaches were chosen
- Captures lessons learned for future reference
- Informal and conversational (scratchpad style)

### 4. Architectural Decision ([docs/adr/0002-jwt-authentication.md](../../../../docs/adr/0002-jwt-authentication.md))
- Formal ADR documenting the JWT vs sessions decision
- Context, decision drivers, options considered
- Clear rationale for the chosen approach
- Consequences (positive, negative, neutral)
- References for future readers

**Key Takeaways:**
- ADRs are for significant architectural decisions
- Shows multiple options were considered
- Explains trade-offs clearly
- Provides references for deeper understanding

---

## How to Use This Example

### For New Users
1. Read [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md) first to see how to structure a task
2. Review [CHECKLIST.md](CHECKLIST.md) to understand completion rigor
3. Skim [NOTES.md](NOTES.md) to see how exploratory work is documented
4. Check the [ADR](../../../../docs/adr/0002-jwt-authentication.md) to see decision documentation

### For Learning the Workflow
Compare the states:
- **Start:** Templates from [.claude/templates/](../../../../.claude/templates/)
- **During:** Files in root directory (conceptually - this is the archive)
- **End:** This archive directory

### Common Questions

**Q: Do all tasks need this much detail?**
A: No. Small tasks (bug fixes, minor tweaks) can have lighter plans. This example shows a medium-complexity feature.

**Q: Should my NOTES.md be this detailed?**
A: Only if it helps you think through the problem. Notes are for YOU, not requirements.

**Q: Do I need an ADR for every task?**
A: No. Only for significant architectural decisions. See [docs/adr/README.md](../../../../docs/adr/README.md) for guidance.

**Q: Is this a real implementation?**
A: No, this is a fictional example for demonstration. Real tasks would include actual code changes.

---

## What's NOT Shown Here

This example doesn't include:
- Actual code files (focus is on process, not implementation)
- Test files (would be in `/tests/` directory)
- Git commits (would be in repository history)
- Pull request (would be in GitHub/GitLab)

In a real project, you'd also have:
- Code changes in `src/`
- Tests in `tests/`
- Git commits with references to this task
- CI/CD pipeline runs

---

## Comparison: What Changed From Templates

### IMPLEMENTATION_PLAN.md
**Template:** Blank sections with placeholders
**Completed:** Fully filled with specific details, acceptance criteria checked off, completion notes added

### CHECKLIST.md
**Template:** Generic checklist items
**Completed:** All items checked, specific to this task (auth-related checks)

### NOTES.md
**Template:** Empty scratchpad
**Completed:** Research findings, decisions, observations, lessons learned

---

## Timeline (Hypothetical)

In a real scenario, this task might have taken:
- **Day 1 Morning:** Planning (read docs, create plan, get approval)
- **Day 1 Afternoon:** Implementation Phase 1-2 (database, services)
- **Day 2 Morning:** Implementation Phase 3-4 (API, middleware)
- **Day 2 Afternoon:** Testing and documentation
- **Day 3:** Review, fixes, ADR creation, archival

**Total:** ~2-3 days for a medium-complexity feature with thorough testing and documentation.

---

## Tips from This Example

1. **Start with acceptance criteria** - Everything flows from these
2. **Plan in phases** - Makes large tasks manageable
3. **Document decisions early** - Don't wait until the end for ADRs
4. **Test security explicitly** - Don't rely on general testing
5. **Notes are scratchpad** - Don't stress about perfect notes
6. **Pivot when needed** - Notice how bcrypt replaced argon2 in notes
7. **Check completion rigorously** - Every checklist item matters

---

**This example is here to help you. Use it as a reference, not a rigid template to copy.**

Different tasks will look different. The key is:
- Clear planning
- Systematic execution
- Thorough verification
- Proper archival

Good luck with your tasks!
