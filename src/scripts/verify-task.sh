#!/bin/bash

# verify-task.sh
# Machine-enforced Definition of Done
# This script validates that all completion criteria are met before a task can be marked as done.

set -e  # Exit on first error

echo "=========================================="
echo "  Definition of Done Verification"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

FAILED=0

# Function to print status
print_status() {
  if [ $1 -eq 0 ]; then
    echo -e "${GREEN}✓${NC} $2"
  else
    echo -e "${RED}✗${NC} $2"
    FAILED=1
  fi
}

# 1. Code Quality Checks
echo "1. Code Quality Checks"
echo "----------------------"

# Linting (example - adjust based on your setup)
if command -v npm &> /dev/null && [ -f "package.json" ]; then
  if grep -q "\"lint\"" package.json; then
    npm run lint &> /dev/null
    print_status $? "Linting passed"
  else
    echo -e "${YELLOW}⊘${NC} No lint script found in package.json"
  fi
else
  echo -e "${YELLOW}⊘${NC} No package.json found, skipping lint check"
fi

# Type checking (example for TypeScript)
if command -v npm &> /dev/null && [ -f "tsconfig.json" ]; then
  if grep -q "\"type-check\"" package.json 2>/dev/null; then
    npm run type-check &> /dev/null
    print_status $? "Type checking passed"
  elif command -v tsc &> /dev/null; then
    tsc --noEmit &> /dev/null
    print_status $? "Type checking passed"
  else
    echo -e "${YELLOW}⊘${NC} TypeScript found but no type-check available"
  fi
else
  echo -e "${YELLOW}⊘${NC} No TypeScript configuration found"
fi

# Formatting (example - prettier)
if command -v npm &> /dev/null && [ -f "package.json" ]; then
  if grep -q "\"format:check\"" package.json; then
    npm run format:check &> /dev/null
    print_status $? "Code formatting verified"
  else
    echo -e "${YELLOW}⊘${NC} No format:check script found"
  fi
fi

echo ""

# 2. Testing
echo "2. Testing"
echo "----------"

if command -v npm &> /dev/null && [ -f "package.json" ]; then
  if grep -q "\"test\"" package.json; then
    npm test &> /dev/null
    print_status $? "All tests passed"
  else
    echo -e "${YELLOW}⊘${NC} No test script found in package.json"
  fi
else
  echo -e "${YELLOW}⊘${NC} No package.json found, skipping tests"
fi

echo ""

# 3. Build Validation
echo "3. Build Validation"
echo "-------------------"

if command -v npm &> /dev/null && [ -f "package.json" ]; then
  if grep -q "\"build\"" package.json; then
    npm run build &> /dev/null
    print_status $? "Build succeeded"
  else
    echo -e "${YELLOW}⊘${NC} No build script found in package.json"
  fi
else
  echo -e "${YELLOW}⊘${NC} No package.json found, skipping build"
fi

echo ""

# 4. Code Hygiene
echo "4. Code Hygiene"
echo "---------------"

# Check for TODO comments without issue references
if grep -r "TODO" src/ --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" 2>/dev/null | grep -v "TODO: #" > /dev/null; then
  print_status 1 "No untracked TODO comments"
  echo "   Found TODO comments without issue references:"
  grep -r "TODO" src/ --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" 2>/dev/null | grep -v "TODO: #" | head -3
else
  print_status 0 "No untracked TODO comments"
fi

# Check for console.log statements
if grep -r "console\.log" src/ --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" 2>/dev/null > /dev/null; then
  print_status 1 "No debugging console.log statements"
  echo "   Found console.log statements:"
  grep -r "console\.log" src/ --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" 2>/dev/null | head -3
else
  print_status 0 "No debugging console.log statements"
fi

# Check for commented-out code blocks
if grep -r "^[[:space:]]*\/\/" src/ --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" 2>/dev/null | grep -E "(function|const|let|var|if|for|while)" > /dev/null; then
  echo -e "${YELLOW}⚠${NC} Warning: Possible commented-out code found"
fi

echo ""

# 5. Security Checks
echo "5. Security Checks"
echo "------------------"

# Check for hardcoded secrets patterns
if grep -rE "(api_key|apikey|api-key|password|passwd|secret|token)[[:space:]]*[:=][[:space:]]*['\"][^'\"]{8,}" src/ --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" 2>/dev/null > /dev/null; then
  print_status 1 "No hardcoded secrets found"
  echo "   Warning: Possible hardcoded secrets detected"
else
  print_status 0 "No hardcoded secrets found"
fi

echo ""

# Final Result
echo "=========================================="
if [ $FAILED -eq 0 ]; then
  echo -e "${GREEN}✓ All verification checks passed!${NC}"
  echo "=========================================="
  exit 0
else
  echo -e "${RED}✗ Some verification checks failed${NC}"
  echo "=========================================="
  echo ""
  echo "Please fix the issues above before marking the task as done."
  exit 1
fi
