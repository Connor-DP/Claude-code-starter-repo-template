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
#          "lint": "ruff check .",
#          "typecheck": "mypy .",
#          "build": "python -m build",
#          "format": "ruff format --check ."
#        }
#      }
#
#    The script will automatically use these commands. No need to edit this file!
#
#    See .claude/settings.json "examples" section for Python, Go, Rust configs.
#
# 2. BLOCKING RULES (What causes verification to fail?)
#    ---------------------------------------------------
#    Configure in .claude/settings.json "verification" section:
#
#      {
#        "verification": {
#          "requiredCoverage": null,
#          "blockOnTodo": false,
#          "blockOnConsole": true,
#          "srcDir": "src",
#          "timeoutSeconds": 300
#        }
#      }
#
# 3. ADDING CUSTOM CHECKS
#    ---------------------
#    Add custom checks to the "Custom Checks" section at the bottom of this script.
#
# 4. SECRET SCANNING
#    ----------------
#    Uses gitleaks if available, falls back to enhanced regex patterns.
#    For production: install gitleaks (https://github.com/gitleaks/gitleaks)
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
CLEANUP_FILES=()

# Cleanup temp files on exit
cleanup() {
    for f in "${CLEANUP_FILES[@]}"; do
        rm -f "$f"
    done
}
trap cleanup EXIT

echo "=========================================="
echo "  Definition of Done Verification"
echo "=========================================="
echo ""

# Helper: Get value from settings.json
get_setting() {
    local key=$1
    local default=$2

    if command -v jq &> /dev/null && [ -f "$SETTINGS_FILE" ]; then
        local value
        value=$(jq -r "$key // empty" "$SETTINGS_FILE" 2>/dev/null)
        if [ -n "$value" ] && [ "$value" != "null" ]; then
            echo "$value"
            return
        fi
    elif [ -f "$SETTINGS_FILE" ] && ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Warning: jq not installed. Using default settings.${NC}" >&2
        echo -e "${YELLOW}Install jq for config-driven verification: https://jqlang.github.io/jq/${NC}" >&2
    fi
    echo "$default"
}

# Helper: Run command with timeout and captured output
run_check() {
    local name="$1"
    local cmd="$2"
    local output_file
    output_file=$(mktemp)
    CLEANUP_FILES+=("$output_file")

    echo -n "$name... "

    # Check if the command's tool exists
    local first_word
    first_word=$(echo "$cmd" | awk '{print $1}')
    if ! command -v "$first_word" &> /dev/null 2>&1; then
        # Handle npm/npx/pip specially — check for package manager
        if [[ "$first_word" =~ ^(npm|npx|yarn|pnpm)$ ]] && ! command -v "$first_word" &> /dev/null; then
            echo -e "${YELLOW}skipped ($first_word not found)${NC}"
            return 0
        fi
    fi

    # Run with timeout if available
    local timeout_cmd=""
    local timeout_secs
    timeout_secs=$(get_setting ".verification.timeoutSeconds" "300")

    if command -v timeout &> /dev/null; then
        timeout_cmd="timeout ${timeout_secs}s"
    elif command -v gtimeout &> /dev/null; then
        # macOS with coreutils
        timeout_cmd="gtimeout ${timeout_secs}s"
    fi

    if $timeout_cmd eval "$cmd" > "$output_file" 2>&1; then
        echo -e "${GREEN}pass${NC}"
        return 0
    else
        local exit_code=$?
        if [ "$exit_code" -eq 124 ]; then
            echo -e "${RED}TIMEOUT (${timeout_secs}s)${NC}"
        else
            echo -e "${RED}fail${NC}"
        fi
        echo "   Command: $cmd"
        echo "   Output:"
        sed 's/^/   /' "$output_file" | head -20
        if [ "$(wc -l < "$output_file")" -gt 20 ]; then
            echo "   ... (output truncated)"
        fi
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
if [ "$LINT_CMD" != "null" ] && [ -n "$LINT_CMD" ]; then
    if [[ "$LINT_CMD" == npm* ]] && [ "$HAS_PACKAGE_JSON" = false ]; then
        echo -e "${YELLOW}skip${NC} Linting (no package.json found)"
    else
        run_check "Linting" "$LINT_CMD" || true
    fi
else
    echo -e "${YELLOW}skip${NC} No lint command configured"
fi

# Type Checking
if [ "$TYPE_CMD" != "null" ] && [ -n "$TYPE_CMD" ]; then
    if [[ "$TYPE_CMD" == npm* ]] && [ "$HAS_PACKAGE_JSON" = false ]; then
        echo -e "${YELLOW}skip${NC} Type checking (no package.json found)"
    else
        run_check "Type checking" "$TYPE_CMD" || true
    fi
else
    echo -e "${YELLOW}skip${NC} No typecheck command configured"
fi

# Formatting
if [ "$FORMAT_CMD" != "null" ] && [ -n "$FORMAT_CMD" ]; then
    if [[ "$FORMAT_CMD" == npm* ]] && [ "$HAS_PACKAGE_JSON" = false ]; then
        echo -e "${YELLOW}skip${NC} Code formatting (no package.json found)"
    else
        run_check "Code formatting" "$FORMAT_CMD" || true
    fi
else
    echo -e "${YELLOW}skip${NC} No format check command configured"
fi

echo ""

# 2. Testing
echo -e "${BLUE}2. Testing${NC}"
echo "----------"

if [ "$TEST_CMD" != "null" ] && [ -n "$TEST_CMD" ]; then
    if [[ "$TEST_CMD" == npm* ]] && [ "$HAS_PACKAGE_JSON" = false ]; then
        echo -e "${YELLOW}skip${NC} Tests (no package.json found)"
    else
        run_check "All tests" "$TEST_CMD" || true
    fi
else
    echo -e "${YELLOW}skip${NC} No test command configured"
fi

echo ""

# 3. Build Validation
echo -e "${BLUE}3. Build Validation${NC}"
echo "-------------------"

if [ "$BUILD_CMD" != "null" ] && [ -n "$BUILD_CMD" ]; then
    if [[ "$BUILD_CMD" == npm* ]] && [ "$HAS_PACKAGE_JSON" = false ]; then
        echo -e "${YELLOW}skip${NC} Build (no package.json found)"
    else
        run_check "Build" "$BUILD_CMD" || true
    fi
else
    echo -e "${YELLOW}skip${NC} No build command configured"
fi

echo ""

# 4. Security Checks
echo -e "${BLUE}4. Security Checks${NC}"
echo "------------------"

echo -n "Scanning for secrets... "

# Try professional tool first (gitleaks)
if command -v gitleaks &> /dev/null; then
    if gitleaks detect --source="$ROOT_DIR" --no-git --redact > /dev/null 2>&1; then
        echo -e "${GREEN}pass (gitleaks)${NC}"
    else
        echo -e "${RED}fail - Secrets detected (gitleaks)${NC}"
        echo "   Run: gitleaks detect --source . --verbose"
        FAILED=1
    fi
# Enhanced grep-based detection
elif [ -d "$ROOT_DIR/$SRC_DIR" ]; then
    SECRET_FOUND=false

    # Extended patterns for better detection
    SECRET_PATTERNS=(
        # API keys and tokens
        "(api[_-]?key|apikey|api[_-]?secret)[[:space:]]*[:=][[:space:]]*['\"][^'\"]{8,}"
        "(access[_-]?token|auth[_-]?token|bearer)[[:space:]]*[:=][[:space:]]*['\"][^'\"]{8,}"
        # Passwords
        "(password|passwd|pwd)[[:space:]]*[:=][[:space:]]*['\"][^'\"]{4,}"
        # AWS credentials
        "AKIA[0-9A-Z]{16}"
        # Private keys
        "-----BEGIN (RSA |EC |DSA )?PRIVATE KEY-----"
        # JWT tokens (3 base64 segments separated by dots)
        "eyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}\."
        # Generic secret/key assignments
        "(secret[_-]?key|private[_-]?key|signing[_-]?key)[[:space:]]*[:=][[:space:]]*['\"][^'\"]{8,}"
        # Connection strings with credentials
        "(mysql|postgres|mongodb|redis)://[^:]+:[^@]+@"
    )

    for pattern in "${SECRET_PATTERNS[@]}"; do
        MATCHES=$(grep -rE "$pattern" "$ROOT_DIR/$SRC_DIR" 2>/dev/null \
            | grep -v "process\.env" \
            | grep -v "os\.environ" \
            | grep -v "os\.Getenv" \
            | grep -v "env::var" \
            | grep -v "//.*" \
            | grep -v "#.*" \
            | grep -v "\.example" \
            | grep -v "\.sample" \
            | grep -v "node_modules" \
            || true)
        if [ -n "$MATCHES" ]; then
            SECRET_FOUND=true
            break
        fi
    done

    if [ "$SECRET_FOUND" = true ]; then
        echo -e "${RED}fail - Possible secrets detected${NC}"
        echo -e "${YELLOW}   Install gitleaks for production-grade scanning: https://github.com/gitleaks/gitleaks${NC}"
        FAILED=1
    else
        echo -e "${GREEN}pass (grep)${NC}"
        echo -e "${YELLOW}   Tip: Install gitleaks for production-grade scanning${NC}"
    fi
else
    echo -e "${YELLOW}skip${NC} Source directory not found"
fi

# Dependency audit
echo -n "Dependency audit... "
if [ "$HAS_PACKAGE_JSON" = true ] && command -v npm &> /dev/null; then
    AUDIT_OUTPUT=$(mktemp)
    CLEANUP_FILES+=("$AUDIT_OUTPUT")
    if npm audit --production 2>/dev/null > "$AUDIT_OUTPUT"; then
        echo -e "${GREEN}pass (npm)${NC}"
    else
        CRITICAL=$(grep -c "critical" "$AUDIT_OUTPUT" 2>/dev/null || echo "0")
        HIGH=$(grep -c "high" "$AUDIT_OUTPUT" 2>/dev/null || echo "0")
        if [ "$CRITICAL" -gt 0 ] || [ "$HIGH" -gt 0 ]; then
            echo -e "${RED}fail - ${CRITICAL} critical, ${HIGH} high vulnerabilities${NC}"
            echo "   Run: npm audit for details"
            FAILED=1
        else
            echo -e "${YELLOW}warn - vulnerabilities found (non-critical)${NC}"
        fi
    fi
elif [ -f "$ROOT_DIR/requirements.txt" ] && command -v pip-audit &> /dev/null; then
    if pip-audit -r "$ROOT_DIR/requirements.txt" > /dev/null 2>&1; then
        echo -e "${GREEN}pass (pip-audit)${NC}"
    else
        echo -e "${RED}fail - vulnerabilities detected${NC}"
        FAILED=1
    fi
elif [ -f "$ROOT_DIR/Cargo.toml" ] && command -v cargo-audit &> /dev/null; then
    if cargo audit > /dev/null 2>&1; then
        echo -e "${GREEN}pass (cargo-audit)${NC}"
    else
        echo -e "${RED}fail - vulnerabilities detected${NC}"
        FAILED=1
    fi
else
    echo -e "${YELLOW}skip${NC} No audit tool available"
fi

echo ""

# 5. Code Hygiene
echo -e "${BLUE}5. Code Hygiene${NC}"
echo "---------------"

# Check for console.log / print debugging (if configured to block)
if [ "$BLOCK_CONSOLE" = "true" ] && [ -d "$ROOT_DIR/$SRC_DIR" ]; then
    echo -n "Debug statements... "
    DEBUG_FOUND=false

    # JavaScript/TypeScript: console.log
    if find "$ROOT_DIR/$SRC_DIR" -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" 2>/dev/null | head -1 | grep -q .; then
        if grep -rn "console\.log\|console\.debug" "$ROOT_DIR/$SRC_DIR" \
            --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" 2>/dev/null \
            | grep -v "//.*console\." \
            | grep -v "\.test\." \
            | grep -v "\.spec\." \
            | grep -v "__tests__" \
            | head -1 > /dev/null 2>&1; then
            DEBUG_FOUND=true
        fi
    fi

    # Python: print()
    if find "$ROOT_DIR/$SRC_DIR" -name "*.py" 2>/dev/null | head -1 | grep -q .; then
        if grep -rn "^\s*print(" "$ROOT_DIR/$SRC_DIR" \
            --include="*.py" 2>/dev/null \
            | grep -v "#.*print" \
            | grep -v "test_" \
            | grep -v "_test\.py" \
            | head -1 > /dev/null 2>&1; then
            DEBUG_FOUND=true
        fi
    fi

    if [ "$DEBUG_FOUND" = true ]; then
        echo -e "${RED}fail - Debug statements in source code${NC}"
        echo "   Remove console.log/print debugging before merging"
        FAILED=1
    else
        echo -e "${GREEN}pass${NC}"
    fi
else
    echo -e "${YELLOW}skip${NC} Debug statement check disabled or no source directory"
fi

# Check for untracked TODOs (if configured to block)
if [ "$BLOCK_TODO" = "true" ] && [ -d "$ROOT_DIR/$SRC_DIR" ]; then
    echo -n "Untracked TODO comments... "
    # Find TODOs without issue references like TODO(#123) or TODO: #123
    STRAY_TODOS=$(grep -r "TODO" "$ROOT_DIR/$SRC_DIR" 2>/dev/null | grep -vE "TODO[\(:][\s]*#" | wc -l | tr -d ' ')

    if [ "$STRAY_TODOS" -gt 0 ]; then
        echo -e "${RED}fail - Found $STRAY_TODOS untracked TODOs${NC}"
        echo "   TODOs should reference issues: TODO(#123) or TODO: #123"
        FAILED=1
    else
        echo -e "${GREEN}pass${NC}"
    fi
else
    echo -e "${YELLOW}skip${NC} TODO check disabled"
fi

# Check for commented-out code
if [ -d "$ROOT_DIR/$SRC_DIR" ]; then
    echo -n "Commented-out code... "
    COMMENTED_CODE=0

    # JS/TS: lines starting with // followed by code keywords
    JS_COMMENTED=$(grep -r "^[[:space:]]*\/\/" "$ROOT_DIR/$SRC_DIR" \
        --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" 2>/dev/null \
        | grep -E "(function|const|let|var|if|for|while|return|import|export)\b" \
        | grep -v "// TODO" \
        | grep -v "// NOTE" \
        | grep -v "// HACK" \
        | wc -l | tr -d ' ')
    COMMENTED_CODE=$((COMMENTED_CODE + JS_COMMENTED))

    # Python: lines starting with # followed by code keywords
    PY_COMMENTED=$(grep -r "^[[:space:]]*#[[:space:]]" "$ROOT_DIR/$SRC_DIR" \
        --include="*.py" 2>/dev/null \
        | grep -E "(def |class |import |from |if |for |while |return )" \
        | grep -v "# TODO" \
        | grep -v "# NOTE" \
        | wc -l | tr -d ' ')
    COMMENTED_CODE=$((COMMENTED_CODE + PY_COMMENTED))

    if [ "$COMMENTED_CODE" -gt 5 ]; then
        echo -e "${YELLOW}warn - Found $COMMENTED_CODE instances${NC}"
        echo "   Consider removing commented-out code"
    else
        echo -e "${GREEN}pass${NC}"
    fi
fi

echo ""

# ============================================================================
# 6. Custom Checks (ADD YOUR PROJECT-SPECIFIC CHECKS BELOW)
# ============================================================================
# echo -e "${BLUE}6. Custom Checks${NC}"
# echo "----------------"
#
# Example: Check for unapplied database migrations
# if [ -d "migrations/pending" ] && [ "$(ls -A migrations/pending)" ]; then
#     echo -e "${RED}fail${NC} Unapplied database migrations found"
#     FAILED=1
# fi
#
# Example: Check bundle size
# if [ -f "dist/bundle.js" ]; then
#     SIZE=$(wc -c < dist/bundle.js)
#     if [ "$SIZE" -gt 500000 ]; then
#         echo -e "${YELLOW}warn${NC} Bundle size is ${SIZE} bytes (>500KB)"
#     fi
# fi

# Final Result
echo "=========================================="
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All verification checks passed!${NC}"
    echo "=========================================="
    echo ""
    echo "Task is ready for review and archival."
    exit 0
else
    echo -e "${RED}Some verification checks failed${NC}"
    echo "=========================================="
    echo ""
    echo "Please fix the issues above before marking the task as done."
    echo ""
    echo "Tip: Check .claude/settings.json to configure commands for your stack."
    exit 1
fi
