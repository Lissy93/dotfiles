#!/bin/bash

# Utilities for checking terminal color support, and printing color palette

TEXT_COL="\033[1;30m"
RESET='\033[0m'

# Outputs the number of colors supported by your terminal emulator
function check_color_support () {
  echo -e "\n${TEXT_COL}Your terminal supports $(tput colors) colors."
}

# Prints main 16 colors
function color_map_16_bit () {
  echo -e "\n${TEXT_COL}16-Bit Pallete${RESET}\n"
  base_colors='40m 41m 42m 43m 44m 45m 46m 47m'
  for BG in $base_colors; do echo -en "$EINS \033[$BG       \033[0m"; done; echo
  for BG in $base_colors; do printf " \033[1;30m\033[%b  %b  \033[0m" $BG $BG; done; echo
  for BG in $base_colors; do echo -en "$EINS \033[$BG       \033[0m"; done; echo
}

# Prints all 256 supported colors
function color_map_256_bit () {
  echo -e "\n${TEXT_COL}256-Bit Pallete${RESET}\n"
  for i in {0..255}; do printf '\e[38;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
  echo
}

# Executes Python script by @grawity for interactivley selecting colors
function color_chooser () {
  curl -s https://raw.githubusercontent.com/grawity/code/master/term/xterm-color-chooser | python3
}

# Determine if file is being run directly or sourced
([[ -n $ZSH_EVAL_CONTEXT && $ZSH_EVAL_CONTEXT =~ :file$ ]] || 
  [[ -n $KSH_VERSION && $(cd "$(dirname -- "$0")" &&
    printf '%s' "${PWD%/}/")$(basename -- "$0") != "${.sh.file}" ]] || 
  [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)) && sourced=1 || sourced=0

# If script being called directly run immediately, otherwise register aliases
if [ $sourced -eq 0 ]; then
  check_color_support
  color_map_16_bit
  color_map_256_bit
else
  alias color-map-16="color_map_16_bit"
  alias color-map-256="color_map_256_bit"
  alias color-map="color_map_16_bit && color_map_256_bit"
  alias color-support="check_color_support"
fi
