#!/bin/bash
# Cycle through all Neovide windows

# Get all Neovide PIDs sorted
pids=($(pgrep neovide | sort -n))

if [ ${#pids[@]} -eq 0 ]; then
    echo "No Neovide windows found"
    exit 1
fi

# Get the PID of the currently focused application
current_pid=$(osascript -e 'tell application "System Events" to get unix id of first process whose frontmost is true' 2>/dev/null)

# Find the index of current PID in the array
current_index=-1
for i in "${!pids[@]}"; do
    if [ "${pids[$i]}" = "$current_pid" ]; then
        current_index=$i
        break
    fi
done

# Determine next PID to activate
if [ $current_index -eq -1 ]; then
    # Current app is not Neovide, activate first one
    next_pid=${pids[0]}
else
    # Activate next Neovide (wrap around if at end)
    next_index=$(( (current_index + 1) % ${#pids[@]} ))
    next_pid=${pids[$next_index]}
fi

# Activate the window using osascript
osascript -e "tell application \"System Events\" to set frontmost of first process whose unix id is $next_pid to true" 2>/dev/null
