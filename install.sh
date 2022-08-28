#!/usr/bin/env bash

# Dotfile setup script
# Fetches latest changes, symlinks files, and installs dependencies
# For docs and more info, see: https://github.com/lissy93/dotfiles
# Licensed under MIT - (C) Alicia Sykes, 2022 <https://aliciasykes.com>

# IMPORTANT: Before running, read through everything, and confirm it's what you want!

# set -e

# Configuration Params
REPO_NAME="Lissy93/Dotfiles"
REPO_PATH="https://github.com/${REPO_NAME}.git"
CONFIG=".install.conf.yaml"
DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"
CURRENT_DIR=$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Documents/config/dotfiles}"
TITLE='🧰 Lissy93/Dotfiles Setup'

# Color Variables
CYAN_B='\033[1;96m'
YELLOW_B='\033[1;93m'
RED_B='\033[1;31m'
GREEN_B='\033[1;32m'
PLAIN_B='\033[1;37m'
RESET='\033[0m'
PURPLE='\033[0;35m'

# Other params
PROMPT_TIMEOUT=15 # When user is prompted for input, skip after x seconds

# Start timer
start_time=`date +%s`

# Get system type - Linux / MacOS (Darwin)
system_type=$(uname -s)

# Function that prints important text in a banner with colored border
# First param is the text to output, then optional color and padding
make_banner () {
  bannerText=$1
  lineColor="${2:-$CYAN_B}"
  padding="${3:-0}"
  titleLen=$(expr ${#bannerText} + 2 + $padding);
  lineChar="─"; line=""
  for (( i = 0; i < "$titleLen"; ++i )); do line="${line}${lineChar}"; done
  banner="${lineColor}╭${line}╮\n│ ${PLAIN_B}${bannerText}${lineColor} │\n╰${line}╯"
  echo -e "\n${banner}\n${RESET}"
}

# Checks if a given package is installed
command_exists () {
  hash "$1" 2> /dev/null
}

# On error, displays death banner, and terminates app with exit code 1
terminate () {
  make_banner "Installation failed. Terminating..." ${RED_B}
  exit 1
}

# Checks if command / package (in $1) exists and then shows
# warning or error + terminates depending if required ($2)
system_verify () {
  if ! command_exists $1; then
    if $2; then
      echo -e "🚫 ${RED_B}Error:${PLAIN_B} $1 is not installed${RESET}"
      terminate
    else
      echo -e "⚠️  ${YELLOW_B}Warning:${PLAIN_B} $1 is not installed${RESET}"
    fi
  fi
}

# Prints welcome banner, verifies that requirements are met
function pre_setup_tasks () {
  # Show starting banner
  make_banner "${TITLE}" "${CYAN_B}" 1

  # Verify required packages are installed
  system_verify "git" true
  system_verify "zsh" false
  system_verify "vim" false
  system_verify "nvim" false
  system_verify "tmux" false
}

# Downloads / updates dotfiles and symlinks them
function setup_dot_files () {

  # Download / update dotfiles repo with git
  if [[ ! -d "$DOTFILES_DIR" ]]
  then
    echo "${PURPLE}Dotfiles not yet present. Will download ${REPO_NAME} into ${DOTFILES_DIR}"
    mkdir -p "${DOTFILES_DIR}"
    git clone --recursive ${REPO_PATH} ${DOTFILES_DIR}
  else
    echo -e "${PURPLE}Pulling changes from ${REPO_NAME} into ${DOTFILES_DIR}"
    cd "${DOTFILES_DIR}" && git pull origin master && git submodule update --recursive
  fi

  # If git clone / pull failed, then exit with error
  ret=$?
  if ! test "$ret" -eq 0
  then
    echo >&2 "${RED_B}Failed to fetch dotfiels $ret${RESET}"
    terminate
  fi

  # Set up symlinks with dotbot
  cd "${DOTFILES_DIR}"
  git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
  git submodule update --init --recursive "${DOTBOT_DIR}"
  chmod +x  dotbot/bin/dotbot
  "${DOTFILES_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${DOTFILES_DIR}" -c "${CONFIG}" "${@}"
}

# Applies application-specific preferences, and runs some setup tasks
function apply_preferences () {

  # If ZSH not the default shell, ask user if they'd like to set it
  if [[ $SHELL != *"zsh"* ]] && command_exists zsh; then
    read -t $PROMPT_TIMEOUT -p "Would you like to set ZSH as your default shell? (y/N)" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      chsh -s $(which zsh) $USER
    fi
  fi

  # Install / update vim plugins with Plug
  vim +PlugInstall +qall

  # Install / update Tmux plugins with TPM
  chmod ug+x "${XDG_DATA_HOME}/tmux/tpm"
}

# Based on system type, uses appropriate package manager to install / updates apps
function install_packages () {

  read -t $PROMPT_TIMEOUT -p "Would you like to install / update system packages? (y/N) " -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n${PURPLE}Skipping package installs${RESET}"
    return
  fi

  # Mac OS
  if [ "$system_type" = "Darwin" ]; then
    # Homebrew not installed, ask user if they'd like to download it now
    if ! command_exists brew; then
      read -t $PROMPT_TIMEOUT -p "Would you like to install Homebrew? (y/N)" -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -en "🍺 ${YELLOW_B}Installing Homebrew...${RESET}\n"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        export PATH=/opt/homebrew/bin:$PATH
      fi
    fi
    # Update / Install the Homebrew packages in ~/.Brewfile
    if command_exists brew && [ -f "$HOME/.Brewfile" ]
    then
      echo -e "${PURPLE}Updating homebrew and packages...${RESET}"
      brew update
      brew upgrade
      BREW_PREFIX=$(brew --prefix)
      brew bundle --global --file $HOME/.Brewfile
      brew cleanup
    fi
  fi
}

# Updates current session, and outputs summary
function finishing_up () {
  # Update source to ZSH entry point
  source "${HOME}/.zshenv"

  # Print success message, and time taken
  total_time=$((`date +%s`-start_time))
  make_banner "✨ Dotfiles configured succesfully in $total_time seconds" ${GREEN_B} 1
  exit 0
}

# Begin!
pre_setup_tasks   # Print start message, and check requirements are met
setup_dot_files   # Clone / updatae dotfiles, and create the symlinks
apply_preferences # Set settings for individual applications
install_packages  # Prompt to install / update OS-specific packages
finishing_up      # Re-source .zshenv, and print summary
# All done!
