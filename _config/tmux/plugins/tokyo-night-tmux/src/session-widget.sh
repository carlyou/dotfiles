#!/usr/bin/env bash

# Imports
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
. "${ROOT_DIR}/src/themes.sh"

# Get current session name
current_session="$(tmux display-message -p '#S')"

# Get all session names
sessions=($(tmux list-sessions -F '#S' 2>/dev/null))

# Build the session list display
session_display=""

# First add the active session
#session_display+="#[fg=${THEME[bblack]},bg=${THEME[blue]},bold]${current_session} #[fg=${THEME[foreground]},bg=${THEME[background]},nobold]"

# Then add other sessions
for session in "${sessions[@]}"; do
    if [ "$session" == "$current_session" ]; then
        session_display+="#[fg=${THEME[bblack]},bg=${THEME[blue]},bold] #{?client_prefix,󰠠 ,#[dim]󰤂 }#[bold,nodim]#[fg=${THEME[bblack]},bg=${THEME[blue]},bold]${session} #[fg=${THEME[foreground]},bg=${THEME[background]},nobold]"
    fi

    if [ "$session" != "$current_session" ]; then
        # Inactive sessions - dimmed
        session_display+="#[fg=${THEME[blue]},bg=${THEME[background]},bold] ${session} #[fg=${THEME[foreground]},bg=${THEME[background]},nobold]"
    fi
done

# Output just the session display
echo "${session_display}"
