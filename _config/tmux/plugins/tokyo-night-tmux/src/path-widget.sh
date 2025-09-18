#!/usr/bin/env bash

# Imports
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
. "${ROOT_DIR}/lib/coreutils-compat.sh"

# get value from tmux config
SHOW_PATH=$(tmux show-option -gv @tokyo-night-tmux_show_path 2>/dev/null)
PATH_FORMAT=$(tmux show-option -gv @tokyo-night-tmux_path_format 2>/dev/null) # full | relative
RESET="#[fg=brightwhite,bg=#15161e,nobold,noitalics,nounderscore,nodim]"

# check if not enabled
if [ "${SHOW_PATH}" != "1" ]; then
  exit 0
fi

current_path="${1}"
default_path_format="relative"
PATH_FORMAT="${PATH_FORMAT:-$default_path_format}"

# check user requested format
if [[ ${PATH_FORMAT} == "relative" ]]; then
  current_path="$(echo ${current_path} | sed 's#'"$HOME"'#~#g')"
elif [[ ${PATH_FORMAT} == "minimal" ]]; then
  # First get the last 3 path segments
  current_path="$(echo ${current_path} | sed 's#'"$HOME"'#~#g')"

  if [[ $(echo "${current_path}" | grep -o '/' | wc -l ) -ge 4 ]]; then
    last_three="$(echo "${current_path}" | rev | cut -d'/' -f1-3 | rev)"
    current_path=".../${last_three}"
  fi
fi

echo "#[fg=blue,bg=default]░  ${RESET}#[bg=default]${current_path} "
