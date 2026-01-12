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

# Counters
ERRORS=0
WARNINGS=0
CHECKS=0

echo -e "${BLUE}🏥 Running environment diagnostics...${NC}\n"

# Helper functions
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((CHECKS++))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((ERRORS++))
    ((CHECKS++))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
    ((CHECKS++))
}

# 1. Check Git
echo -e "${BLUE}Git Configuration${NC}"
if command -v git &> /dev/null; then
    check_pass "Git is installed ($(git --version | cut -d' ' -f3))"

    if git rev-parse --git-dir > /dev/null 2>&1; then
        check_pass "Inside a Git repository"

        # Check if user is configured
        if git config user.name &> /dev/null && git config user.email &> /dev/null; then
            check_pass "Git user configured"
        else
            check_warn "Git user not configured (run: git config user.name/user.email)"
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
    if [ -f "$file" ]; then
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
    if [ -d "$dir" ]; then
        check_pass "$dir/ exists"
    else
        check_fail "$dir/ is missing"
    fi
done
echo ""

# 4. Check for Active Tasks
echo -e "${BLUE}Active Task State${NC}"
if [ -f "IMPLEMENTATION_PLAN.md" ]; then
    check_pass "Active task detected (IMPLEMENTATION_PLAN.md)"

    if [ -f "CHECKLIST.md" ]; then
        check_pass "CHECKLIST.md exists"
    else
        check_warn "IMPLEMENTATION_PLAN.md exists but CHECKLIST.md is missing"
    fi

    if [ -f "NOTES.md" ]; then
        check_pass "NOTES.md exists"
    else
        check_warn "NOTES.md is missing (optional but recommended)"
    fi
else
    check_pass "No active task (clean state)"
fi
echo ""

# 5. Check Environment Configuration
echo -e "${BLUE}Environment Configuration${NC}"

# Check if .env exists but is not in .gitignore
if [ -f ".env" ]; then
    if grep -q "^\.env$" .gitignore 2>/dev/null; then
        check_pass ".env file exists and is gitignored"
    else
        check_fail ".env file exists but NOT in .gitignore (security risk!)"
    fi
fi

# Check for .gitignore
if [ -f ".gitignore" ]; then
    check_pass ".gitignore exists"
else
    check_warn ".gitignore not found"
fi

# Check node_modules is gitignored (if Node.js project)
if [ -f "package.json" ]; then
    if grep -q "node_modules" .gitignore 2>/dev/null; then
        check_pass "node_modules is gitignored"
    else
        check_warn "node_modules should be in .gitignore"
    fi
fi
echo ""

# 6. Check Language/Runtime Environment
echo -e "${BLUE}Language/Runtime Environment${NC}"

# Detect project type from settings.json
if [ -f ".claude/settings.json" ]; then
    # Node.js
    if grep -q '"language".*"typescript"' .claude/settings.json || grep -q '"language".*"javascript"' .claude/settings.json; then
        if command -v node &> /dev/null; then
            check_pass "Node.js is installed ($(node --version))"
        else
            check_fail "Node.js not found (project uses Node.js)"
        fi

        if command -v npm &> /dev/null; then
            check_pass "npm is installed ($(npm --version))"
        else
            check_fail "npm not found"
        fi
    fi

    # Python
    if grep -q '"language".*"python"' .claude/settings.json; then
        if command -v python3 &> /dev/null; then
            check_pass "Python is installed ($(python3 --version | cut -d' ' -f2))"
        else
            check_fail "Python not found (project uses Python)"
        fi

        if command -v pip3 &> /dev/null; then
            check_pass "pip is installed"
        else
            check_warn "pip not found"
        fi
    fi

    # Go
    if grep -q '"language".*"go"' .claude/settings.json; then
        if command -v go &> /dev/null; then
            check_pass "Go is installed ($(go version | cut -d' ' -f3))"
        else
            check_fail "Go not found (project uses Go)"
        fi
    fi

    # Rust
    if grep -q '"language".*"rust"' .claude/settings.json; then
        if command -v cargo &> /dev/null; then
            check_pass "Rust/Cargo is installed ($(cargo --version | cut -d' ' -f2))"
        else
            check_fail "Rust not found (project uses Rust)"
        fi
    fi
fi
echo ""

# 7. Check Dependencies
echo -e "${BLUE}Dependencies${NC}"

if [ -f "package.json" ]; then
    if [ -d "node_modules" ]; then
        check_pass "node_modules exists"
    else
        check_warn "node_modules not found (run: npm install)"
    fi
fi

if [ -f "requirements.txt" ]; then
    if [ -d "venv" ] || [ -d ".venv" ]; then
        check_pass "Python virtual environment detected"
    else
        check_warn "Virtual environment not found (recommended for Python)"
    fi
fi

if [ -f "Cargo.toml" ]; then
    if [ -d "target" ]; then
        check_pass "Cargo build artifacts exist"
    else
        check_warn "No build artifacts (run: cargo build)"
    fi
fi
echo ""

# 8. Check Scripts are Executable
echo -e "${BLUE}Script Permissions${NC}"
scripts=(
    "src/scripts/task.sh"
    "src/scripts/verify-task.sh"
    "src/scripts/doctor.sh"
)

for script in "${scripts[@]}"; do
    if [ -f "$script" ]; then
        if [ -x "$script" ]; then
            check_pass "$script is executable"
        else
            check_warn "$script exists but is not executable (run: chmod +x $script)"
        fi
    fi
done
echo ""

# 9. Check for Common Issues
echo -e "${BLUE}Common Issues${NC}"

# Check for console.log in source
if command -v grep &> /dev/null; then
    if [ -d "src" ]; then
        console_logs=$(grep -r "console\.log" src/ 2>/dev/null | wc -l | tr -d ' ')
        if [ "$console_logs" -gt 0 ]; then
            check_warn "Found $console_logs console.log statements in src/"
        else
            check_pass "No console.log statements found"
        fi
    fi
fi

# Check for TODO comments
if [ -d "src" ]; then
    todos=$(grep -r "TODO" src/ 2>/dev/null | wc -l | tr -d ' ')
    if [ "$todos" -gt 0 ]; then
        check_warn "Found $todos TODO comments in src/"
    else
        check_pass "No TODO comments found"
    fi
fi

# Check for hardcoded secrets patterns
if [ -d "src" ]; then
    secrets=$(grep -ri "api[_-]key\|password.*=.*['\"]" src/ 2>/dev/null | grep -v "process.env" | wc -l | tr -d ' ')
    if [ "$secrets" -gt 0 ]; then
        check_fail "Possible hardcoded secrets detected!"
    else
        check_pass "No obvious hardcoded secrets"
    fi
fi
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
    echo -e "${GREEN}✓ Environment is healthy!${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ Environment is functional but has warnings${NC}"
    exit 0
else
    echo -e "${RED}✗ Environment has errors that need attention${NC}"
    exit 1
fi
