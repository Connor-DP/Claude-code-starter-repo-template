#!/bin/bash
# Task Lifecycle Management Script
# Usage:
#   ./src/scripts/task.sh start "feature-name"
#   ./src/scripts/task.sh finish "feature-name"

set -e  # Exit on error

ACTION=$1
TASK_NAME=$2
DATE=$(date +%Y-%m-%d)
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

error() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

success() {
    echo -e "${GREEN}✓ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

info() {
    echo "→ $1"
}

# Check if action is provided
if [ -z "$ACTION" ]; then
    error "Action required. Usage: ./src/scripts/task.sh [start|finish] [task-name]"
fi

# START command
if [ "$ACTION" == "start" ]; then
    if [ -z "$TASK_NAME" ]; then
        error "Task name required. Usage: ./src/scripts/task.sh start \"task-name\""
    fi

    # Check if task already active
    if [ -f "$ROOT_DIR/IMPLEMENTATION_PLAN.md" ]; then
        error "Task already active. Run './src/scripts/task.sh finish' first or archive manually."
    fi

    info "Starting new task: $TASK_NAME"

    # Copy templates to root
    cp "$ROOT_DIR/.claude/templates/IMPLEMENTATION_PLAN.md" "$ROOT_DIR/IMPLEMENTATION_PLAN.md"
    cp "$ROOT_DIR/.claude/templates/CHECKLIST.md" "$ROOT_DIR/CHECKLIST.md"
    cp "$ROOT_DIR/.claude/templates/NOTES.md" "$ROOT_DIR/NOTES.md"

    # Replace [YYYY-MM-DD] placeholder with actual date
    sed -i.bak "s/\[YYYY-MM-DD\]/$DATE/g" "$ROOT_DIR/IMPLEMENTATION_PLAN.md"
    rm "$ROOT_DIR/IMPLEMENTATION_PLAN.md.bak"

    # Replace [Task Title] placeholder with actual task name
    TASK_TITLE=$(echo "$TASK_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')
    sed -i.bak "s/\[Task Title\]/$TASK_TITLE/g" "$ROOT_DIR/IMPLEMENTATION_PLAN.md"
    rm "$ROOT_DIR/IMPLEMENTATION_PLAN.md.bak"

    success "Task '$TASK_NAME' started"
    info "Files created in root directory:"
    echo "  - IMPLEMENTATION_PLAN.md"
    echo "  - CHECKLIST.md"
    echo "  - NOTES.md"
    echo ""
    info "Next steps:"
    echo "  1. Edit IMPLEMENTATION_PLAN.md to define your approach"
    echo "  2. Use CHECKLIST.md to track progress"
    echo "  3. Use NOTES.md for exploratory context"
    echo "  4. When done: ./src/scripts/task.sh finish \"$TASK_NAME\""

# FINISH command
elif [ "$ACTION" == "finish" ]; then
    if [ -z "$TASK_NAME" ]; then
        error "Task name required. Usage: ./src/scripts/task.sh finish \"task-name\""
    fi

    # Check if task files exist
    if [ ! -f "$ROOT_DIR/IMPLEMENTATION_PLAN.md" ]; then
        error "No active task found. IMPLEMENTATION_PLAN.md missing."
    fi

    info "Finishing task: $TASK_NAME"

    # Run verification script
    if [ -f "$ROOT_DIR/src/scripts/verify-task.sh" ]; then
        info "Running verification script..."
        if ! bash "$ROOT_DIR/src/scripts/verify-task.sh"; then
            error "Verification failed. Fix issues before archiving."
        fi
        success "Verification passed"
    else
        warning "Verification script not found. Skipping verification."
    fi

    # Create archive directory
    TARGET="$ROOT_DIR/ai/TASKS/archive/$DATE-$TASK_NAME"
    mkdir -p "$TARGET"

    # Move files to archive
    mv "$ROOT_DIR/IMPLEMENTATION_PLAN.md" "$TARGET/"
    mv "$ROOT_DIR/CHECKLIST.md" "$TARGET/"
    mv "$ROOT_DIR/NOTES.md" "$TARGET/" 2>/dev/null || warning "NOTES.md not found, skipping"

    success "Task archived to ai/TASKS/archive/$DATE-$TASK_NAME"
    info "Root directory cleared and ready for next task"

# LIST command (bonus)
elif [ "$ACTION" == "list" ]; then
    info "Active task:"
    if [ -f "$ROOT_DIR/IMPLEMENTATION_PLAN.md" ]; then
        TASK_TITLE=$(grep "^## Task:" "$ROOT_DIR/IMPLEMENTATION_PLAN.md" | sed 's/## Task: //')
        STATUS=$(grep "^\*\*Status\*\*:" "$ROOT_DIR/IMPLEMENTATION_PLAN.md" | sed 's/\*\*Status\*\*: //' | sed 's/`//g')
        echo "  $TASK_TITLE - Status: $STATUS"
    else
        echo "  None"
    fi

    echo ""
    info "Archived tasks:"
    if [ -d "$ROOT_DIR/ai/TASKS/archive" ]; then
        ls -1 "$ROOT_DIR/ai/TASKS/archive" | sed 's/^/  /'
    else
        echo "  None"
    fi

# HELP command
elif [ "$ACTION" == "help" ] || [ "$ACTION" == "-h" ] || [ "$ACTION" == "--help" ]; then
    echo "Task Lifecycle Management"
    echo ""
    echo "Usage:"
    echo "  ./src/scripts/task.sh start \"task-name\"   - Start a new task"
    echo "  ./src/scripts/task.sh finish \"task-name\"  - Finish and archive current task"
    echo "  ./src/scripts/task.sh list                  - List active and archived tasks"
    echo "  ./src/scripts/task.sh help                  - Show this help"
    echo ""
    echo "Examples:"
    echo "  ./src/scripts/task.sh start \"add-user-authentication\""
    echo "  ./src/scripts/task.sh finish \"add-user-authentication\""

else
    error "Unknown action: $ACTION. Use 'start', 'finish', 'list', or 'help'."
fi
