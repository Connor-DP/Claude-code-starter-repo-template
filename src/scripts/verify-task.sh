#!/bin/bash

# verify-task.sh - The Quality Gatekeeper
# Config-driven verification that works across all languages/stacks
#
# ============================================================================
# CUSTOMIZATION GUIDE
# ============================================================================
#
# This script is designed to be LANGUAGE AGNOSTIC and CONFIG-DRIVEN.
#
# 1. CHANGING COMMANDS (test, lint, build, etc.)
#    -------------------------------------------
#    Most commands are configured in .claude/settings.json, NOT in this script.
#
#    To change from Node.js to Python:
#      Open .claude/settings.json and update the "commands" section:
#
#      {
#        "commands": {
#          "test": "pytest",
#          "lint": "flake8 .",
#          "typecheck": "mypy .",
#          "build": "python -m build",
#          "format": "black --check ."
#        }
#      }
#
#    The script will automatically use these commands. No need to edit this file!
#
#    See .claude/settings.json → "examples" section for Python, Go, Rust configs.
#
# 2. BLOCKING RULES (What causes verification to fail?)
#    ---------------------------------------------------
#    Configure in .claude/settings.json → "verification" section:
#
#      {
#        "verification": {
#          "requiredCoverage": null,        // Set to number like 80 to require coverage
#          "blockOnTodo": false,             // Set to true to fail if TODO comments found
#          "blockOnConsole": true,           // Fails if console.log found in src/
#          "srcDir": "src"                   // Directory to scan for anti-patterns
#        }
#      }
#
# 3. ADDING CUSTOM CHECKS
#    ---------------------
#    If you need project-specific checks (e.g., database migrations, custom linting),
#    add them to the "Custom Checks" section at the bottom of this script.
#
#    Example:
#      echo "Checking database migrations..."
#      if [ -d "migrations/pending" ] && [ "$(ls -A migrations/pending)" ]; then
#          echo "❌ Unapplied database migrations found"
#          FAILED=1
#      fi
#
# 4. SECRET SCANNING
#    ----------------
#    This script uses gitleaks if available, falls back to grep patterns.
#    To customize secret patterns, edit the SECRET_PATTERNS array below.
#
# 5. GETTING HELP
#    ------------
#    If verification fails, the script shows:
#    - The exact command that failed
#    - The first 20 lines of output
#    - Where to look for more details
#
#    For debugging, run commands manually:
#      npm test        # Or whatever your test command is
#      npm run lint    # Or whatever your lint command is
#
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SETTINGS_FILE="$ROOT_DIR/.claude/settings.json"

FAILED=0

echo "=========================================="
echo "  Definition of Done Verification"
echo "=========================================="
echo ""

# Helper: Get value from settings.json
get_setting() {
    local key=$1
    local default=$2

    if command -v jq &> /dev/null && [ -f "$SETTINGS_FILE" ]; then
        local value=$(jq -r "$key // empty" "$SETTINGS_FILE" 2>/dev/null)
        if [ ! -z "$value" ] && [ "$value" != "null" ]; then
            echo "$value"
            return
        fi
    fi
    echo "$default"
}

# Helper: Run command with captured output
run_check() {
    local name="$1"
    local cmd="$2"
    local output_file=$(mktemp)

    echo -n "$name... "

    if eval "$cmd" > "$output_file" 2>&1; then
        echo -e "${GREEN}✓${NC}"
        rm -f "$output_file"
        return 0
    else
        echo -e "${RED}✗${NC}"
        echo "   Command: $cmd"
        echo "   Output:"
        sed 's/^/   /' "$output_file" | head -20
        if [ $(wc -l < "$output_file") -gt 20 ]; then
            echo "   ... (output truncated)"
        fi
        rm -f "$output_file"
        FAILED=1
        return 1
    fi
}

# Get commands from config
TEST_CMD=$(get_setting ".commands.test" "npm test")
LINT_CMD=$(get_setting ".commands.lint" "npm run lint")
TYPE_CMD=$(get_setting ".commands.typecheck" "npm run typecheck")
BUILD_CMD=$(get_setting ".commands.build" "npm run build")
FORMAT_CMD=$(get_setting ".commands.format" "npm run format:check")
SRC_DIR=$(get_setting ".verification.srcDir" "src")
BLOCK_TODO=$(get_setting ".verification.blockOnTodo" "false")
BLOCK_CONSOLE=$(get_setting ".verification.blockOnConsole" "true")

# Check if this is a Node.js project with package.json
HAS_PACKAGE_JSON=false
if [ -f "$ROOT_DIR/package.json" ]; then
    HAS_PACKAGE_JSON=true
fi

# 1. Code Quality Checks
echo -e "${BLUE}1. Code Quality Checks${NC}"
echo "----------------------"

# Linting
if [ "$LINT_CMD" != "null" ] && [ ! -z "$LINT_CMD" ]; then
    # Skip npm commands if no package.json exists
    if [[ "$LINT_CMD" == npm* ]] && [ "$HAS_PACKAGE_JSON" = false ]; then
        echo -e "${YELLOW}⊘${NC} Linting skipped (no package.json found)"
    else
        run_check "Linting" "$LINT_CMD"
    fi
else
    echo -e "${YELLOW}⊘${NC} No lint command configured"
fi

# Type Checking
if [ "$TYPE_CMD" != "null" ] && [ ! -z "$TYPE_CMD" ]; then
    if [[ "$TYPE_CMD" == npm* ]] && [ "$HAS_PACKAGE_JSON" = false ]; then
        echo -e "${YELLOW}⊘${NC} Type checking skipped (no package.json found)"
    else
        run_check "Type checking" "$TYPE_CMD"
    fi
else
    echo -e "${YELLOW}⊘${NC} No typecheck command configured"
fi

# Formatting
if [ "$FORMAT_CMD" != "null" ] && [ ! -z "$FORMAT_CMD" ]; then
    if [[ "$FORMAT_CMD" == npm* ]] && [ "$HAS_PACKAGE_JSON" = false ]; then
        echo -e "${YELLOW}⊘${NC} Code formatting skipped (no package.json found)"
    else
        run_check "Code formatting" "$FORMAT_CMD"
    fi
else
    echo -e "${YELLOW}⊘${NC} No format check command configured"
fi

echo ""

# 2. Testing
echo -e "${BLUE}2. Testing${NC}"
echo "----------"

if [ "$TEST_CMD" != "null" ] && [ ! -z "$TEST_CMD" ]; then
    if [[ "$TEST_CMD" == npm* ]] && [ "$HAS_PACKAGE_JSON" = false ]; then
        echo -e "${YELLOW}⊘${NC} Tests skipped (no package.json found)"
    else
        run_check "All tests" "$TEST_CMD"
    fi
else
    echo -e "${YELLOW}⊘${NC} No test command configured"
fi

echo ""

# 3. Build Validation
echo -e "${BLUE}3. Build Validation${NC}"
echo "-------------------"

if [ "$BUILD_CMD" != "null" ] && [ ! -z "$BUILD_CMD" ]; then
    if [[ "$BUILD_CMD" == npm* ]] && [ "$HAS_PACKAGE_JSON" = false ]; then
        echo -e "${YELLOW}⊘${NC} Build skipped (no package.json found)"
    else
        run_check "Build" "$BUILD_CMD"
    fi
else
    echo -e "${YELLOW}⊘${NC} No build command configured"
fi

echo ""

# 4. Security Checks
echo -e "${BLUE}4. Security Checks${NC}"
echo "------------------"

echo -n "Scanning for secrets... "

# Try professional tool first (gitleaks)
if command -v gitleaks &> /dev/null; then
    if gitleaks detect --source="$ROOT_DIR" --no-git --redact > /dev/null 2>&1; then
        echo -e "${GREEN}✓ (via gitleaks)${NC}"
    else
        echo -e "${RED}✗ Secrets detected (via gitleaks)${NC}"
        FAILED=1
    fi
# Fallback to grep-based detection
elif [ -d "$ROOT_DIR/$SRC_DIR" ]; then
    # Look for common secret patterns
    if grep -rE "(api[_-]?key|apikey|password|passwd|secret[_-]?key|access[_-]?token|auth[_-]?token)[[:space:]]*[:=][[:space:]]*['\"][^'\"]{8,}" "$ROOT_DIR/$SRC_DIR" 2>/dev/null | grep -v "process.env" | grep -v "//"; then
        echo -e "${RED}✗ Possible secrets detected${NC}"
        echo -e "${YELLOW}   Tip: Install 'gitleaks' for better detection${NC}"
        FAILED=1
    else
        echo -e "${GREEN}✓ (via grep)${NC}"
    fi
else
    echo -e "${YELLOW}⊘ Source directory not found${NC}"
fi

echo ""

# 5. Code Hygiene
echo -e "${BLUE}5. Code Hygiene${NC}"
echo "---------------"

# Check for console.log (if configured to block)
if [ "$BLOCK_CONSOLE" = "true" ] && [ -d "$ROOT_DIR/$SRC_DIR" ]; then
    echo -n "Console.log statements... "
    if grep -r "console\.log" "$ROOT_DIR/$SRC_DIR" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" 2>/dev/null | grep -v "//"; then
        echo -e "${RED}✗ Found console.log${NC}"
        echo "   Remove debugging console.log statements"
        FAILED=1
    else
        echo -e "${GREEN}✓${NC}"
    fi
else
    echo -e "${YELLOW}⊘${NC} Console.log check disabled or no source directory"
fi

# Check for untracked TODOs (if configured to block)
if [ "$BLOCK_TODO" = "true" ] && [ -d "$ROOT_DIR/$SRC_DIR" ]; then
    echo -n "Untracked TODO comments... "
    # Find TODOs without issue references like TODO(#123) or TODO: #123
    STRAY_TODOS=$(grep -r "TODO" "$ROOT_DIR/$SRC_DIR" 2>/dev/null | grep -vE "TODO[\(:][\s]*#" | wc -l | tr -d ' ')

    if [ "$STRAY_TODOS" -gt 0 ]; then
        echo -e "${RED}✗ Found $STRAY_TODOS untracked TODOs${NC}"
        echo "   TODOs should reference issues: TODO(#123) or TODO: #123"
        FAILED=1
    else
        echo -e "${GREEN}✓${NC}"
    fi
else
    echo -e "${YELLOW}⊘${NC} TODO check disabled"
fi

# Check for commented-out code
if [ -d "$ROOT_DIR/$SRC_DIR" ]; then
    echo -n "Commented-out code... "
    COMMENTED_CODE=$(grep -r "^[[:space:]]*\/\/" "$ROOT_DIR/$SRC_DIR" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" 2>/dev/null | grep -E "(function|const|let|var|if|for|while)" | wc -l | tr -d ' ')

    if [ "$COMMENTED_CODE" -gt 0 ]; then
        echo -e "${YELLOW}⚠ Found $COMMENTED_CODE instances${NC}"
        echo "   Consider removing commented-out code"
    else
        echo -e "${GREEN}✓${NC}"
    fi
fi

echo ""

# Final Result
echo "=========================================="
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All verification checks passed!${NC}"
    echo "=========================================="
    echo ""
    echo "Task is ready for review and archival."
    exit 0
else
    echo -e "${RED}✗ Some verification checks failed${NC}"
    echo "=========================================="
    echo ""
    echo "Please fix the issues above before marking the task as done."
    echo ""
    echo "Tip: Check .claude/settings.json to configure commands for your stack."
    exit 1
fi
