#!/bin/bash

# Configuration
CONFIRM_FILE="$HOME/.git_push_confirm"
CONFIRM_INTERVAL=$((12 * 3600))  # 12 hours in seconds

# Function to check if confirmation is needed
need_confirmation() {
    # If confirmation file doesn't exist, need confirmation
    if [ ! -f "$CONFIRM_FILE" ]; then
        return 0
    fi

    # Read last confirmation timestamp
    last_confirm=$(cat "$CONFIRM_FILE")
    current_time=$(date +%s)

    # Check if enough time has passed since last confirmation
    if [ $((current_time - last_confirm)) -gt "$CONFIRM_INTERVAL" ]; then
        return 0
    else
        return 1
    fi
}

# Function to update confirmation timestamp
update_confirmation() {
    date +%s > "$CONFIRM_FILE"
}

# Function to handle git operations with confirmation
git_push_with_confirm() {
    if need_confirmation; then
        echo "This will execute: git add . && git commit -m \"Dev changes\" && git push origin main"
        echo -n "Are you sure? (y/n): "
        read confirm
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
            update_confirmation
            execute_git_commands
        else
            echo "Operation cancelled."
            return 1
        fi
    else
        execute_git_commands
    fi
}

# Function to execute git commands
execute_git_commands() {
    echo "Executing git commands..."
    git add . && \
    git commit -m "Dev changes" && \
    git push origin main

    if [ $? -eq 0 ]; then
        echo "Git operations completed successfully."
    else
        echo "Git operations failed."
        return 1
    fi
}

# Remove any existing alias or function
unalias gp 2>/dev/null || true
unset -f gp 2>/dev/null || true

# Define the function properly
function gp {
    git_push_with_confirm
}
export -f gp

# Show initial message when sourced
echo "Git push command 'gp' has been mapped."
echo "Use 'gp' to execute: git add . && git commit -m \"Dev changes\" && git push origin main"