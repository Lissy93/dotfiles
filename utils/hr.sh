#!/bin/bash

# Simple script to output a solid line in the terminal
# Useful for marking the end of a task in your bash log
# Inspired by @LuRsT's script of the same name
# Licensed under MIT (C) Alicia Sykes, 2021

# Determine width of terminal
COLS="$(tput cols)"
if (( COLS <= 0 )) ; then
    COLS="${COLUMNS:-80}"
fi

# Colors
CYAN_BG="\u001b[46;1m"
RESET="\u001b[0m"

# Prints the HR line
hr() {
    local CHAR="$1"
    local LINE=''
    LINE=$(printf "%*s" "$COLS")
    LINE="${LINE// /${CHAR}}"
    printf "${CYAN_BG}${LINE:0:${COLS}}${RESET}"
}

# Passes param and calls hr()
start() {
    for WORD in "${@:--}"; do
        hr "$WORD"
    done
}

# Catch errors, and call start
[ "$0" == "$BASH_SOURCE" ] && start "$@"