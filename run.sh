#!/bin/bash

# Configuration
LOG_DIR="./logs"
COMMANDS_DIR="."  # Directory where command scripts are stored
LOG_FILE="${LOG_DIR}/run.log"

# Create logs directory if it doesn't exist
mkdir -p "${LOG_DIR}"

# Function to log messages
log_message() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[${timestamp}] $1" >> "${LOG_FILE}"
    echo "$1"
}

# Function to list available commands
list_commands() {
    log_message "Available commands:"
    # Use find to search recursively for *_cmd.sh files and store in an array
    local -a cmd_files
    while IFS= read -r cmd_file; do
        if [ -f "$cmd_file" ]; then
            cmd_files+=("$cmd_file")
        fi
    done < <(find "${COMMANDS_DIR}" -type f -name "*_cmd.sh" | sort)

    # Process and display each command
    for cmd_file in "${cmd_files[@]}"; do
        # Extract command name without _cmd.sh
        command_name=$(basename "$cmd_file" _cmd.sh)
        # Get parent directory name
        parent_dir=$(dirname "$cmd_file")
        # Get the topmost parent directory
        top_parent=$(echo "$parent_dir" | cut -d'/' -f1)

        # If we're in current directory, don't show parent
        if [ "$parent_dir" = "." ]; then
            echo "  - $command_name"
            log_message "Listed command: $command_name"
        else
            echo "  - [$top_parent] $command_name"
            log_message "Listed command: [$top_parent] $command_name"
        fi
    done
}

# Function to execute a command
execute_command() {
    local command_name="$1"
    local cmd_script=""

    # Search recursively for the command script
    cmd_script=$(find "${COMMANDS_DIR}" -type f -name "${command_name}_cmd.sh" | head -n 1)

    if [ -n "$cmd_script" ]; then
        log_message "Executing command: $command_name (script: $cmd_script)"
        if [ -x "$cmd_script" ]; then
            bash "$cmd_script"
            local exit_code=$?
            if [ $exit_code -eq 0 ]; then
                log_message "Command $command_name completed successfully"
            else
                log_message "Command $command_name failed with exit code $exit_code"
            fi
        else
            log_message "Error: Command script $cmd_script is not executable"
            chmod +x "$cmd_script"
            log_message "Made script executable, retrying..."
            bash "$cmd_script"
        fi
    else
        log_message "Error: Command $command_name not found"
        echo "Available commands are:"
        list_commands
        return 1
    fi
}

# Main script logic
if [ $# -eq 0 ]; then
    log_message "No command specified"
    echo "Usage: $0 <command>"
    list_commands
    exit 1
fi

command_name="$1"
shift  # Remove first argument, leaving remaining args for the command

case "$command_name" in
    "list")
        list_commands
        ;;
    *)
        execute_command "$command_name" "$@"
        ;;
esac