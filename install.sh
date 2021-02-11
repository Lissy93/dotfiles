#!/usr/bin/env bash

# Variables
CYAN_BOLD='\033[1;96m'
YELLOW_BOLD='\033[1;93m'
RED_BOLD='\033[1;31m'
PLAIN_BOLD='\033[1;37m'

# Print Welcome Message
printf "${CYAN_BOLD}"
printf "╭──────────────────────╮\n"
printf "│ "
printf "${PLAIN_BOLD}"
printf "Dotfile Setup Script "
printf "${CYAN_BOLD}"
printf "│\n"
printf "╰──────────────────────╯\n"

# Checks if a given package is installed
command_exists () {
  hash "$1" 2> /dev/null
}

# Shows warning if required modules are missing
system_verify () {
  if ! command_exists $1; then
    printf "${YELLOW_BOLD}Warning:"
    printf "${PLAIN_BOLD} $1 is not installed\n"
  fi
}

system_verify "zsh"
system_verify "vim"
system_verify "git"
system_verify "tmux"


set -e

CONFIG=".install.conf.yaml"
DOTBOT_DIR=".dotbot"
DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASEDIR}"
git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
git submodule update --init --recursive "${DOTBOT_DIR}"

"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"
