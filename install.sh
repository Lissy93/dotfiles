#!/bin/bash

######################################################################
# 🧰 Lissy93/Dotfiles - All-in-One Install and Setup Script for Unix #
######################################################################
# Fetches latest changes, symlinks files, and installs dependencies  #
# Then sets up ZSH, TMUX, Vim as well as OS-specific tools and apps  #
# For docs and more info, see: https://github.com/lissy93/dotfiles   #
#                                                                    #
# IMPORTANT: Before running, read through everything very carefully! #
#                                                                    #
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
######################################################################

# Configuration Params
REPO_NAME="${REPO_NAME:-Lissy93/Dotfiles}"
REPO_PATH="https://github.com/${REPO_NAME}.git"
SYMLINK_FILE="${SYMLINK_FILE:-symlinks.yaml}"
DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"
CURRENT_DIR=$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Documents/config/dotfiles}"
TITLE="🧰 ${REPO_NAME} Setup"

# Color Variables
CYAN_B='\033[1;96m'
YELLOW_B='\033[1;93m'
RED_B='\033[1;31m'
GREEN_B='\033[1;32m'
PLAIN_B='\033[1;37m'
RESET='\033[0m'
GREEN='\033[0;32m'
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
# either shows a warning or error, depending if package required ($2)
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
    echo -e "${PURPLE}Dotfiles not yet present. Will download ${REPO_NAME} into ${DOTFILES_DIR}${RESET}"
    mkdir -p "${DOTFILES_DIR}"
    git clone --recursive ${REPO_PATH} ${DOTFILES_DIR}
  else
    echo -e "${PURPLE}Pulling changes from ${REPO_NAME} into ${DOTFILES_DIR}${RESET}"
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
  echo -e "${PURPLE}Setting up Symlinks${RESET}"
  cd "${DOTFILES_DIR}"
  git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
  git submodule update --init --recursive "${DOTBOT_DIR}"
  chmod +x  dotbot/bin/dotbot
  "${DOTFILES_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${DOTFILES_DIR}" -c "${SYMLINK_FILE}" "${@}"
}

# Applies application-specific preferences, and runs some setup tasks
function apply_preferences () {

  # If ZSH not the default shell, ask user if they'd like to set it
  if [[ $SHELL != *"zsh"* ]] && command_exists zsh; then
    read -t $PROMPT_TIMEOUT -p "$(echo -e $CYAN_B)Would you like to set ZSH as your default shell? (y/N)" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo -e "${PURPLE}Setting ZSH as default shell${RESET}"
      chsh -s $(which zsh) $USER
    fi
  fi

  # Install / update vim plugins with Plug
  echo -e "${PURPLE}Installing Vim Plugins${RESET}"
  vim +PlugInstall +qall

  # Install / update Tmux plugins with TPM
  echo -e "${PURPLE}Installing TMUX Plugins${RESET}"
  chmod ug+x "${XDG_DATA_HOME}/tmux/tpm"
  sh "${TMUX_PLUGIN_MANAGER_PATH}/tpm/bin/install_plugins"
  sh "${XDG_DATA_HOME}/tmux/plugins/tpm/bin/install_plugins"
  

  # Install / update ZSH plugins with Antigen
  echo -e "${PURPLE}Installing ZSH Plugins${RESET}"
  /bin/zsh -i -c "antigen update && antigen-apply"
}

# Setup Brew, install / update packages, organize launchpad and checks for macOS updates
function intall_macos_packages () {
  # Homebrew not installed, ask user if they'd like to download it now
  if ! command_exists brew; then
    read -t $PROMPT_TIMEOUT -p "$(echo -e $CYAN_B)Would you like to install Homebrew? (y/N)" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo -en "🍺 ${PURPLE}Installing Homebrew...${RESET}\n"
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
    brew bundle --global --file $HOME/.Brewfile
    brew cleanup
  else
    echo -e "${PURPLE}Skipping Homebrew as requirements not met${RESET}"
  fi
  # Restore launchpad structure with lporg
  if ! command_exists lporg && [ -f "$DOTFILES_DIR/configs/macos/launchpad.yml" ]; then
    echo -e "${PURPLE}Restoring Launchpad Layout...${RESET}"
    lporg load "$DOTFILES_DIR/configs/macos/launchpad.yml"
  fi
  # Check for MacOS software updates, and ask user if they'd like to install
  echo -e "${PURPLE}Checking for software updates...${RESET}"
  pending_updates=$(softwareupdate -l 2>&1)
  if [[ ! $pending_updates == *"No new software available."* ]]; then
    read -t $PROMPT_TIMEOUT -p "$(echo -e $CYAN_B)A new macOS software update is available.\
    Would you like to install it now?$(echo -e $RESET) (y/N)" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      softwareupdate -i -a
    fi
  else
    echo -e "${GREEN}System is up-to-date."\
    "Running $(sw_vers -productName) version $(sw_vers -productVersion)${RESET}"
  fi
}

# Based on system type, uses appropriate package manager to install / updates apps
function install_packages () {

  read -t $PROMPT_TIMEOUT -p "$(echo -e $CYAN_B)Would you like to install / update system packages? (y/N) " -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n${PURPLE}Skipping package installs${RESET}"
    return
  fi
  # Ask for users password
  echo -e "\n${PURPLE}Some install steps may require elevated permissions.${CYAN_B}\n\
  You can enter your password now, to avoid typing it for each stage, or Ctrl+C to skip.${RESET}"
  sudo -v
  # Mac OS
  if [ "$system_type" = "Darwin" ]; then
    intall_macos_packages
  fi
}

# Updates current session, and outputs summary
function finishing_up () {
  # Update source to ZSH entry point
  source "${HOME}/.zshenv"

  # Print success message, and time taken
  total_time=$((`date +%s`-start_time))
  make_banner "✨ Dotfiles configured succesfully in $total_time seconds" ${GREEN_B} 1
  
  # Exit script with success code
  exit 0
}

# Let's Begin!
pre_setup_tasks   # Print start message, and check requirements are met
setup_dot_files   # Clone / updatae dotfiles, and create the symlinks
apply_preferences # Apply settings for individual applications
install_packages  # Prompt to install / update OS-specific packages
finishing_up      # Refresh current session, print summary and exit
# All done :)
