#!/bin/bash

# Default values
verbosity=""
limit=""
tags="jumphost"

# Function to display help
function display_help {
  echo "Usage: $0 [OPTIONS]"
  echo
  echo "Available options:"
  echo "  -v                Enable verbosity (-vvvv)"
  echo "  -l LIMIT          Set the limit (e.g., 'desktop')"
  echo "  -t TAGS           Set the tags (e.g., 'jumphost')"
  echo "  --help            Display this help message"
  exit 0
}

# Parse input arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -v) verbosity="-vvvv" ;;
    -l) limit="$2"; shift ;;
    -t) tags="$2"; shift ;;
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

# Run ansible-playbook with the provided or default arguments
ansible-playbook $verbosity -i inventory.ini playbook.yml --limit $limit --tags $tags --become-password-file password
