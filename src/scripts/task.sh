#!/bin/bash
# Task Lifecycle Management Script
# Usage:
#   ./src/scripts/task.sh start "feature-name"
#   ./src/scripts/task.sh finish "feature-name"
#   ./src/scripts/task.sh list

set -e  # Exit on error

ACTION=$1
TASK_NAME=$2
DATE=$(date +%Y-%m-%d)
TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)
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
    echo -e "${GREEN}$1${NC}"
}

warning() {
    echo -e "${YELLOW}$1${NC}"
}

info() {
    echo "$1"
}

# Portable sed -i (works on both macOS and Linux)
sed_inplace() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "$@"
    else
        sed -i "$@"
    fi
}

# Check if action is provided
if [ -z "$ACTION" ]; then
    error "Action required. Usage: ./src/scripts/task.sh [start|finish|list|help] [task-name]"
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

    # Validate templates exist
    for tmpl in IMPLEMENTATION_PLAN.md CHECKLIST.md NOTES.md; do
        if [ ! -f "$ROOT_DIR/.claude/templates/$tmpl" ]; then
            error "Template missing: .claude/templates/$tmpl"
        fi
    done

    info "Starting new task: $TASK_NAME"

    # Copy templates to root
    cp "$ROOT_DIR/.claude/templates/IMPLEMENTATION_PLAN.md" "$ROOT_DIR/IMPLEMENTATION_PLAN.md"
    cp "$ROOT_DIR/.claude/templates/CHECKLIST.md" "$ROOT_DIR/CHECKLIST.md"
    cp "$ROOT_DIR/.claude/templates/NOTES.md" "$ROOT_DIR/NOTES.md"

    # Replace placeholders (portable sed)
    sed_inplace "s/\[YYYY-MM-DD\]/$DATE/g" "$ROOT_DIR/IMPLEMENTATION_PLAN.md"

    TASK_TITLE=$(echo "$TASK_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')
    sed_inplace "s/\[Task Title\]/$TASK_TITLE/g" "$ROOT_DIR/IMPLEMENTATION_PLAN.md"

    # Install pre-commit hook if git repo and not already installed
    if [ -d "$ROOT_DIR/.git" ] && [ ! -f "$ROOT_DIR/.git/hooks/pre-commit" ]; then
        info "Installing pre-commit hook..."
        cat > "$ROOT_DIR/.git/hooks/pre-commit" << 'EOF'
#!/bin/bash
# Auto-installed pre-commit hook for task verification

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if [ -f "$SCRIPT_DIR/src/scripts/verify-task.sh" ]; then
    echo "Running pre-commit verification..."
    if ! bash "$SCRIPT_DIR/src/scripts/verify-task.sh"; then
        echo "Verification failed. Fix issues before committing."
        echo "   To skip verification (not recommended): git commit --no-verify"
        exit 1
    fi
    echo "Verification passed"
fi
EOF
        chmod +x "$ROOT_DIR/.git/hooks/pre-commit"
        success "Pre-commit hook installed"
    fi

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
    if [ -f "$ROOT_DIR/src/scripts/verify-task.sh" ] && [ -x "$ROOT_DIR/src/scripts/verify-task.sh" ]; then
        info "Running verification script..."
        if ! bash "$ROOT_DIR/src/scripts/verify-task.sh"; then
            error "Verification failed. Fix issues before archiving."
        fi
        success "Verification passed"
    elif [ -f "$ROOT_DIR/src/scripts/verify-task.sh" ]; then
        warning "verify-task.sh found but not executable. Run: chmod +x src/scripts/verify-task.sh"
        info "Running verification anyway..."
        if ! bash "$ROOT_DIR/src/scripts/verify-task.sh"; then
            error "Verification failed. Fix issues before archiving."
        fi
        success "Verification passed"
    else
        warning "Verification script not found. Skipping verification."
    fi

    # Create archive directory with timestamp to prevent collisions
    TARGET="$ROOT_DIR/ai/TASKS/archive/$DATE-$TASK_NAME"
    if [ -d "$TARGET" ]; then
        # Collision — append timestamp
        TARGET="$ROOT_DIR/ai/TASKS/archive/$TIMESTAMP-$TASK_NAME"
    fi

    # Atomic archive: stage in temp dir, then move
    STAGING=$(mktemp -d)
    trap "rm -rf '$STAGING'" EXIT

    cp "$ROOT_DIR/IMPLEMENTATION_PLAN.md" "$STAGING/"
    cp "$ROOT_DIR/CHECKLIST.md" "$STAGING/"
    [ -f "$ROOT_DIR/NOTES.md" ] && cp "$ROOT_DIR/NOTES.md" "$STAGING/"

    # Move staging to archive (atomic on same filesystem)
    mkdir -p "$(dirname "$TARGET")"
    mv "$STAGING" "$TARGET"
    trap - EXIT  # Clear trap since staging was moved

    # Only remove root files after archive is confirmed
    if [ -d "$TARGET" ] && [ -f "$TARGET/IMPLEMENTATION_PLAN.md" ]; then
        rm -f "$ROOT_DIR/IMPLEMENTATION_PLAN.md"
        rm -f "$ROOT_DIR/CHECKLIST.md"
        rm -f "$ROOT_DIR/NOTES.md"
        success "Task archived to ai/TASKS/archive/$(basename "$TARGET")"
        info "Root directory cleared and ready for next task"
    else
        error "Archive failed. Root files preserved."
    fi

# LIST command
elif [ "$ACTION" == "list" ]; then
    info "Active task:"
    if [ -f "$ROOT_DIR/IMPLEMENTATION_PLAN.md" ]; then
        TASK_TITLE=$(grep -E "^#.*Task:|^# Implementation Plan:" "$ROOT_DIR/IMPLEMENTATION_PLAN.md" | head -1 | sed 's/^#* *//')
        STATUS=$(grep -oE "Status:.*" "$ROOT_DIR/IMPLEMENTATION_PLAN.md" | head -1 | sed 's/Status:[[:space:]]*//' | sed 's/\*//g')
        echo "  ${TASK_TITLE:-Unknown} - Status: ${STATUS:-Unknown}"
    else
        echo "  None"
    fi

    echo ""
    info "Archived tasks:"
    if [ -d "$ROOT_DIR/ai/TASKS/archive" ] && [ "$(ls -A "$ROOT_DIR/ai/TASKS/archive" 2>/dev/null)" ]; then
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
