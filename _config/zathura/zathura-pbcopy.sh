#!/bin/bash

# zathura-pbcopy.sh — copy Zathura’s current selection into the macOS clipboard
#
# add following line to your zathurarc file:
#map Y exec /Users/<user>/.config/zathura/zathura-pbcopy.sh

# If xclip is installed, grab the PRIMARY selection from X11;
# otherwise, just read whatever’s on stdin.

DISPLAY=:0 /opt/homebrew/bin/xclip -selection primary -out | pbcopy
