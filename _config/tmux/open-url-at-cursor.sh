#!/bin/bash

# Script to open URLs and file paths from tmux pane content
# Similar to WezTerm's hyperlink functionality

BUFFER_FILE="/tmp/tmux-buffer"

if [[ ! -f "$BUFFER_FILE" ]]; then
    echo "No tmux buffer found"
    exit 1
fi

# Function to resolve relative paths
resolve_path() {
    local path="$1"
    local cwd="$2"
    
    if [[ "$path" =~ ^~/ ]]; then
        # Expand ~ to home directory
        echo "${HOME}${path:1}"
    elif [[ "$path" =~ ^\.\/ ]]; then
        # Resolve ./ relative to current working directory
        echo "${cwd}/${path:2}"
    elif [[ "$path" =~ ^\.\.\/ ]]; then
        # Resolve ../ relative to parent of current working directory
        local parent_dir=$(dirname "$cwd")
        echo "${parent_dir}/${path:3}"
    elif [[ "$path" =~ ^/ ]]; then
        # Absolute path
        echo "$path"
    else
        # Relative path without ./ prefix
        echo "${cwd}/$path"
    fi
}

# Extract URLs and file paths from buffer
extract_links() {
    local buffer_content="$1"
    
    # Find HTTP/HTTPS URLs
    echo "$buffer_content" | grep -oE 'https?://[^[:space:]]+' 
    
    # Find file:// URLs
    echo "$buffer_content" | grep -oE 'file://[^[:space:]]+'
    
    # Find file paths with extensions (including line numbers)
    echo "$buffer_content" | grep -oE '[~./]?[A-Za-z0-9._/-]+\.[A-Za-z0-9]+(:[0-9]+)?'
    
    # Find absolute paths
    echo "$buffer_content" | grep -oE '/[A-Za-z0-9._/-]+'
}

# Get current working directory from tmux
CWD=$(tmux display-message -p '#{pane_current_path}')

# Read buffer content
BUFFER_CONTENT=$(cat "$BUFFER_FILE")

# Extract all potential links
LINKS=$(extract_links "$BUFFER_CONTENT")

if [[ -z "$LINKS" ]]; then
    echo "No URLs or file paths found in current pane"
    exit 0
fi

# If multiple links found, use the last one (most recent)
SELECTED_LINK=$(echo "$LINKS" | tail -n 1)

echo "Opening: $SELECTED_LINK"

# Handle the link similar to WezTerm logic
if [[ "$SELECTED_LINK" =~ :[0-9]+$ ]]; then
    # File with line number - open with neovide
    LINE_NUMBER=$(echo "$SELECTED_LINK" | grep -oE '[0-9]+$')
    FILE_PATH=$(echo "$SELECTED_LINK" | sed 's/:[0-9]*$//')
    RESOLVED_PATH=$(resolve_path "$FILE_PATH" "$CWD")
    
    echo "Opening $RESOLVED_PATH at line $LINE_NUMBER with neovide"
    neovide --fork "+$LINE_NUMBER" "$RESOLVED_PATH" &
elif [[ "$SELECTED_LINK" =~ ^https?:// ]]; then
    # HTTP/HTTPS URL
    echo "Opening URL: $SELECTED_LINK"
    open "$SELECTED_LINK" &
elif [[ "$SELECTED_LINK" =~ ^file:// ]]; then
    # File URL
    echo "Opening file URL: $SELECTED_LINK"
    open "$SELECTED_LINK" &
else
    # Regular file path
    RESOLVED_PATH=$(resolve_path "$SELECTED_LINK" "$CWD")
    echo "Opening file: $RESOLVED_PATH"
    open "$RESOLVED_PATH" &
fi