#!/bin/bash

# Default values
verbosity=""
limit=""
tags="jumphost"
extra_vars=()

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
    -l) limit="$2"; shift ;;
    -t) tags="$2"; shift ;;
    -e) extra_vars+=("$2"); shift ;;
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

# Construct the extra vars arguments
extra_vars_string=""
for var in "${extra_vars[@]}"; do
  extra_vars_string+=" -e '$var'"
done

# Run ansible-playbook with the provided or default arguments
eval "ansible-playbook $verbosity -i inventory.ini playbook.yml --limit $limit --tags $tags$extra_vars_string --become-password-file password"