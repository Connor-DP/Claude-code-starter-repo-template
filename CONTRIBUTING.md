# Contributing to AI-Assisted Development Template

Thank you for considering contributing! This template helps Product Owners and developers build better software with AI assistants.

## Ways to Contribute

### 1. Report Issues
Found a problem or have a suggestion?
- Open an issue describing what you encountered
- Include your use case and context
- Suggest improvements if you have ideas

### 2. Improve Documentation
- Fix typos or unclear explanations
- Add examples or use cases
- Improve starter prompts
- Translate documentation

### 3. Enhance the Template
- Improve scripts (task.sh, verify-task.sh)
- Add new agent personas
- Create additional command workflows
- Optimize token usage further

### 4. Share Your Experience
- Write about how you use this template
- Create video tutorials
- Share success stories
- Help others in discussions

## How to Contribute Code

### 1. Fork & Clone
```bash
git fork https://github.com/YOUR-USERNAME/ai-dev-template
git clone https://github.com/YOUR-USERNAME/ai-dev-template
cd ai-dev-template
```

### 2. Create a Branch
```bash
git checkout -b feature/your-improvement
```

### 3. Make Changes
- Follow the existing structure
- Update relevant documentation
- Test your changes
- Run `./src/scripts/verify-task.sh` if adding features
- Check [docs/ANTI_PATTERNS.md](docs/ANTI_PATTERNS.md) for constraints

### 4. Before Submitting PR

**Checklist:**
- [ ] Documentation updated (README, relevant docs)
- [ ] Examples added if introducing new features
- [ ] Scripts tested on macOS and Linux (if applicable)
- [ ] No breaking changes to core workflow (or clearly documented)
- [ ] ADR created for architectural changes

### 5. Submit PR
- Describe what you changed and why
- Reference any related issues
- Ensure CI checks pass (if applicable)
- Include before/after examples if relevant

## Guidelines

### Code Style
- Keep scripts simple and well-commented
- Use clear, descriptive names
- Follow existing patterns

### Documentation
- Update README.md if adding features
- Add examples where helpful
- Keep language accessible (non-technical users included)

### Philosophy
This template is built on these principles:
1. **Single Source of Truth** - Clear document hierarchy
2. **State Machine Discipline** - One task at a time
3. **Completion Rigor** - Quality gates before "done"
4. **Token Efficiency** - Optimize for AI context windows
5. **Accessibility** - Non-developers should be able to use this

Keep these in mind when contributing.

## Working with Claude (AI Assistant)

If you're using Claude to help with contributions:

### Best Practices
1. **Start with context:**
   ```
   I want to contribute to the AI-assisted development template.
   Please read CLAUDE.md to understand the structure.
   I want to [describe your contribution goal].
   ```

2. **Use the workflow for template improvements:**
   - Let Claude create an `IMPLEMENTATION_PLAN.md` for your contribution
   - Review the plan before implementing
   - Follow the same discipline you'd use in a real project

3. **Test thoroughly:**
   - AI-generated changes should be reviewed by humans
   - Test scripts on multiple platforms if changing bash scripts
   - Verify documentation accuracy

## Questions?

Open a discussion or issue! We're here to help.

**For Security Issues:** Please email [maintainer] privately instead of opening a public issue.

---

## Code of Conduct

Be respectful, constructive, and helpful. This is a learning community.

### Expected Behavior
- Welcome newcomers and help them learn
- Provide constructive feedback
- Focus on what's best for the community
- Show empathy towards other community members

### Unacceptable Behavior
- Harassment or discriminatory language
- Trolling or insulting comments
- Spam or off-topic content
- Publishing others' private information

---

## Recognition

Contributors are recognized in:
- GitHub contributors list
- Release notes for significant contributions
- Special thanks in README for major enhancements

Thank you for helping improve this template! 🚀
