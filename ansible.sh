#!/bin/bash

# Default values
verbosity=""
limit=""
tags="jumphost"
declare -a extra_vars

# Function to display help
function display_help {
  echo "Usage: $0 [OPTIONS]"
  echo
  echo "Available options:"
  echo "  -v                Enable verbosity (-vvvv)"
  echo "  -l LIMIT          Set the limit (e.g., 'desktop')"
  echo "  -t TAGS           Set the tags (e.g., 'jumphost')"
  echo "  -e KEY=VALUE      Set extra variables (can be used multiple times)"
  echo "  --help            Display this help message"
  exit 0
}

# Parse input arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -v) verbosity="-vvvv" ;;
    -l)
      shift
      limit="$1"
      ;;
    -t)
      shift
      tags="$1"
      ;;
    -e)
      shift
      extra_vars+=("--extra-vars")
      extra_vars+=("$1")
      ;;
    --help) display_help ;;
    *) echo "Invalid option: $1"; display_help ;;
  esac
  shift
done

# Error handling for missing -l option (limit)
if [ -z "$limit" ]; then
  echo "Error: The -l (limit) option is required."
  echo "This is needed to avoid potential fact errors such as reachability issues to other hosts."
  exit 1
fi

# Build the command array
cmd=(ansible-playbook)
[[ -n "$verbosity" ]] && cmd+=("$verbosity")
cmd+=(-i inventory.ini playbook.yml --limit "$limit" --tags "$tags")
[[ ${#extra_vars[@]} -gt 0 ]] && cmd+=("${extra_vars[@]}")
cmd+=(--become-password-file password)

# Execute the command
"${cmd[@]}"