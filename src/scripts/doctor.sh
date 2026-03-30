#!/bin/bash

# Doctor Script - Environment Validation
# Checks if the development environment is properly configured

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Counters
ERRORS=0
WARNINGS=0
CHECKS=0

echo -e "${BLUE}Running environment diagnostics...${NC}\n"

# Helper functions
check_pass() {
    echo -e "${GREEN}pass${NC} $1"
    CHECKS=$((CHECKS + 1))
}

check_fail() {
    echo -e "${RED}FAIL${NC} $1"
    ERRORS=$((ERRORS + 1))
    CHECKS=$((CHECKS + 1))
}

check_warn() {
    echo -e "${YELLOW}warn${NC} $1"
    WARNINGS=$((WARNINGS + 1))
    CHECKS=$((CHECKS + 1))
}

# 1. Check Git
echo -e "${BLUE}Git Configuration${NC}"
if command -v git &> /dev/null; then
    check_pass "Git is installed ($(git --version | cut -d' ' -f3))"

    if git -C "$ROOT_DIR" rev-parse --git-dir > /dev/null 2>&1; then
        check_pass "Inside a Git repository"

        if git config user.name &> /dev/null && git config user.email &> /dev/null; then
            check_pass "Git user configured ($(git config user.name) <$(git config user.email)>)"
        else
            check_warn "Git user not configured (run: git config user.name/user.email)"
        fi

        # Check for signing key (recommended for production)
        if git config user.signingkey &> /dev/null; then
            check_pass "Git commit signing configured"
        else
            check_warn "Git commit signing not configured (recommended for production)"
        fi
    else
        check_warn "Not inside a Git repository"
    fi
else
    check_fail "Git is not installed"
fi
echo ""

# 2. Check Required Files
echo -e "${BLUE}Required Files${NC}"
required_files=(
    "CLAUDE.md"
    ".claude/settings.json"
    "ai/DEFINITIONS/DONE_DEFINITION.md"
    "docs/PRD.md"
    "docs/TECH_SPEC.md"
    "docs/ANTI_PATTERNS.md"
    "src/scripts/task.sh"
    "src/scripts/verify-task.sh"
)

for file in "${required_files[@]}"; do
    if [ -f "$ROOT_DIR/$file" ]; then
        check_pass "$file exists"
    else
        check_fail "$file is missing"
    fi
done
echo ""

# 3. Check Directory Structure
echo -e "${BLUE}Directory Structure${NC}"
required_dirs=(
    ".claude/agents"
    ".claude/commands"
    ".claude/templates"
    "ai/TASKS/archive"
    "docs/adr"
    "tests"
)

for dir in "${required_dirs[@]}"; do
    if [ -d "$ROOT_DIR/$dir" ]; then
        check_pass "$dir/ exists"
    else
        check_fail "$dir/ is missing"
    fi
done
echo ""

# 4. Check Agent Definitions
echo -e "${BLUE}Agent Definitions${NC}"
expected_agents=("architect" "qa" "reviewer" "scout" "security-auditor" "implementer" "doc-writer")
for agent in "${expected_agents[@]}"; do
    agent_file="$ROOT_DIR/.claude/agents/${agent}.md"
    if [ -f "$agent_file" ]; then
        # Verify it has YAML frontmatter
        if head -1 "$agent_file" | grep -q "^---"; then
            check_pass "Agent @${agent} defined with frontmatter"
        else
            check_warn "Agent @${agent} exists but missing YAML frontmatter"
        fi
    else
        check_warn "Agent @${agent} not found (.claude/agents/${agent}.md)"
    fi
done
echo ""

# 5. Check for Active Tasks
echo -e "${BLUE}Active Task State${NC}"
if [ -f "$ROOT_DIR/IMPLEMENTATION_PLAN.md" ]; then
    check_pass "Active task detected (IMPLEMENTATION_PLAN.md)"

    if [ -f "$ROOT_DIR/CHECKLIST.md" ]; then
        check_pass "CHECKLIST.md exists"
    else
        check_warn "IMPLEMENTATION_PLAN.md exists but CHECKLIST.md is missing"
    fi

    if [ -f "$ROOT_DIR/NOTES.md" ]; then
        check_pass "NOTES.md exists"
    else
        check_warn "NOTES.md is missing (optional but recommended)"
    fi
else
    check_pass "No active task (clean state)"
fi
echo ""

# 6. Check Environment Configuration
echo -e "${BLUE}Environment Configuration${NC}"

# Check if .env exists but is not in .gitignore
if [ -f "$ROOT_DIR/.env" ]; then
    if grep -q "^\.env$" "$ROOT_DIR/.gitignore" 2>/dev/null; then
        check_pass ".env file exists and is gitignored"
    else
        check_fail ".env file exists but NOT in .gitignore (security risk!)"
    fi
fi

if [ -f "$ROOT_DIR/.gitignore" ]; then
    check_pass ".gitignore exists"
else
    check_warn ".gitignore not found"
fi

# Check for Claude Code hooks
if [ -f "$ROOT_DIR/.claude/settings.json" ] && command -v jq &> /dev/null; then
    if jq -e '.hooks' "$ROOT_DIR/.claude/settings.json" > /dev/null 2>&1; then
        check_pass "Claude Code hooks configured in settings.json"
    else
        check_warn "No Claude Code hooks configured (add hooks to .claude/settings.json)"
    fi
fi
echo ""

# 7. Check Language/Runtime Environment
echo -e "${BLUE}Language/Runtime Environment${NC}"

if [ -f "$ROOT_DIR/.claude/settings.json" ]; then
    # Case-insensitive grep
    if grep -qi '"language".*"typescript\|javascript"' "$ROOT_DIR/.claude/settings.json" 2>/dev/null || [ -f "$ROOT_DIR/package.json" ]; then
        if command -v node &> /dev/null; then
            NODE_VER=$(node --version | sed 's/v//')
            NODE_MAJOR=$(echo "$NODE_VER" | cut -d. -f1)
            if [ "$NODE_MAJOR" -ge 20 ]; then
                check_pass "Node.js $NODE_VER (LTS)"
            elif [ "$NODE_MAJOR" -ge 18 ]; then
                check_warn "Node.js $NODE_VER (EOL — upgrade to 20+)"
            else
                check_fail "Node.js $NODE_VER (unsupported — upgrade to 20+)"
            fi
        else
            check_fail "Node.js not found"
        fi

        if command -v npm &> /dev/null; then
            check_pass "npm $(npm --version)"
        else
            check_fail "npm not found"
        fi
    fi

    if grep -qi '"language".*"python"' "$ROOT_DIR/.claude/settings.json" 2>/dev/null || [ -f "$ROOT_DIR/requirements.txt" ] || [ -f "$ROOT_DIR/pyproject.toml" ]; then
        if command -v python3 &> /dev/null; then
            check_pass "Python $(python3 --version | cut -d' ' -f2)"
        else
            check_fail "Python not found"
        fi
    fi

    if grep -qi '"language".*"go"' "$ROOT_DIR/.claude/settings.json" 2>/dev/null || [ -f "$ROOT_DIR/go.mod" ]; then
        if command -v go &> /dev/null; then
            check_pass "Go $(go version | cut -d' ' -f3)"
        else
            check_fail "Go not found"
        fi
    fi

    if grep -qi '"language".*"rust"' "$ROOT_DIR/.claude/settings.json" 2>/dev/null || [ -f "$ROOT_DIR/Cargo.toml" ]; then
        if command -v cargo &> /dev/null; then
            check_pass "Rust $(cargo --version | cut -d' ' -f2)"
        else
            check_fail "Rust not found"
        fi
    fi
fi

# Check for essential tools
if command -v jq &> /dev/null; then
    check_pass "jq installed (required for config-driven scripts)"
else
    check_warn "jq not installed — scripts will use defaults (install: https://jqlang.github.io/jq/)"
fi

if command -v gitleaks &> /dev/null; then
    check_pass "gitleaks installed (production-grade secret scanning)"
else
    check_warn "gitleaks not installed — using grep fallback (install: https://github.com/gitleaks/gitleaks)"
fi
echo ""

# 8. Check Dependencies
echo -e "${BLUE}Dependencies${NC}"

if [ -f "$ROOT_DIR/package.json" ]; then
    if [ -d "$ROOT_DIR/node_modules" ]; then
        check_pass "node_modules exists"
    else
        check_warn "node_modules not found (run: npm install)"
    fi
fi

if [ -f "$ROOT_DIR/requirements.txt" ]; then
    if [ -d "$ROOT_DIR/venv" ] || [ -d "$ROOT_DIR/.venv" ]; then
        check_pass "Python virtual environment detected"
    else
        check_warn "Virtual environment not found (recommended for Python)"
    fi
fi

if [ -f "$ROOT_DIR/Cargo.toml" ]; then
    if [ -d "$ROOT_DIR/target" ]; then
        check_pass "Cargo build artifacts exist"
    else
        check_warn "No build artifacts (run: cargo build)"
    fi
fi
echo ""

# 9. Check Scripts are Executable
echo -e "${BLUE}Script Permissions${NC}"
scripts=(
    "src/scripts/task.sh"
    "src/scripts/verify-task.sh"
    "src/scripts/doctor.sh"
)

for script in "${scripts[@]}"; do
    if [ -f "$ROOT_DIR/$script" ]; then
        if [ -x "$ROOT_DIR/$script" ]; then
            check_pass "$script is executable"
        else
            check_warn "$script exists but is not executable (run: chmod +x $script)"
        fi
    fi
done
echo ""

# Summary
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "Total checks: $CHECKS"
echo -e "${GREEN}Passed: $((CHECKS - ERRORS - WARNINGS))${NC}"
echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
echo -e "${RED}Errors: $ERRORS${NC}"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}Environment is healthy!${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}Environment is functional but has warnings${NC}"
    exit 0
else
    echo -e "${RED}Environment has errors that need attention${NC}"
    exit 1
fi
