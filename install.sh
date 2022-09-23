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

# Clear the screen
clear

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

# Explain to the user what changes will be made
make_intro () {
  C2="\033[0;35m"
  C3="\x1b[2m"
  echo -e "${CYAN_B}The seup script will do the following:${RESET}"
  echo -e "${C2}(1) Pre-Setup Tasls"
  echo -e "  ${C3}- Check that all requirements are met, and system is compatible"
  echo -e "${C2}(2) Setup Dotfiles"
  echo -e "  ${C3}- Clone or update dotfiles from git, and apply symlinks"
  echo -e "${C2}(3) Install packages"
  echo -e "  ${C3}- Update packeges, and prompt to install apps"
  echo -e "${C2}(4) Configure sytstem"
  echo -e "  ${C3}- Setup Vim, Tmux and ZSH plugins"
  echo -e "  ${C3}- Configure OS and apply app user preferences"
  echo -e "\n${PURPLE}You will be prompted at each stage, before any changes are made.${RESET}"
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

  # Print list of what will be applied
  make_intro

  # Confirm user would like to proceed
  echo -e "\n${CYAN_B}Are you happy to continue? (y/N)${RESET}"
  read -t $PROMPT_TIMEOUT -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n${PURPLE}No worries, feel free to come back another time.\nTerminating...${RESET}"
    exit 0
  fi
  echo

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

  # Apply general system, app and OS security preferences (prompt user first)
  read -t $PROMPT_TIMEOUT -p "$(echo -e $CYAN_B)Would you like to apply system preferences? (y/N)" -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ "$system_type" = "Darwin" ]; then
      echo -e "\n${PURPLE}Applying MacOS system preferences, ensure you've understood before proceeding${RESET}\n"
      macos_settings_dir="$DOTFILES_DIR/system-specific/macos/system-settings"
      for macScript in "macos-security.sh" "macos-preferences.sh" "macos-apps.sh"; do
        chmod +x $macos_settings_dir/$macScript && $macos_settings_dir/$macScript --quick-exit
      done
    fi
  fi
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
  if command_exists brew && [ -f "$DOTFILES_DIR/installs/Brewfile" ]
  then
    echo -e "\n${PURPLE}Updating homebrew and packages...${RESET}"
    brew update
    brew upgrade
    brew bundle --global --file $HOME/.Brewfile
    brew cleanup
  else
    echo -e "${PURPLE}Skipping Homebrew as requirements not met${RESET}"
  fi
  # Restore launchpad structure with lporg
  launchpad_layout="${DOTFILES_DIR}/system-specific/macos/app-configs/launchpad.yml"
  if command_exists lporg && [ -f $launchpad_layout ]; then
    echo -e "${PURPLE}Restoring Launchpad Layout...${RESET}"
    yes "" | lporg load $launchpad_layout
  fi
  # Check for MacOS software updates, and ask user if they'd like to install
  echo -e "${PURPLE}Checking for software updates...${RESET}"
  pending_updates=$(softwareupdate -l 2>&1)
  if [[ ! $pending_updates == *"No new software available."* ]]; then
    echo -e "${PURPLE}A new version of Mac OS is availbile${RESET}"
    read -t $PROMPT_TIMEOUT -p "$(echo -e $CYAN_B)Would you like to update to the latest version of MacOS? (y/N)" -n 1 -r
    echo -e "${RESET}"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo "${PURPLE}Updating MacOS${RESET}"
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
  echo -e "\033[0;92m     .--.\n    |o_o |\n    |:_/ |\n   // \
  \ \\ \n  (|     | ) \n /'\_   _/\`\\ \n \\___)=(___/\n"
  
  # Refresh ZSH sesssion
  SKIP_WELCOME=true || exec zsh

  # Exit script with success code
  echo -e "${CYAN_B}Press any key to exit.${RESET}\n"
  read -t $PROMPT_TIMEOUT -n 1 -s
  exit 0
}

# If --help flag passed in, just show the help menu
if [[ $* == "--help" ]]; then
  make_intro
  exit 0
fi

# Let's Begin!
pre_setup_tasks   # Print start message, and check requirements are met
setup_dot_files   # Clone / updatae dotfiles, and create the symlinks
install_packages  # Prompt to install / update OS-specific packages
apply_preferences # Apply settings for individual applications
finishing_up      # Refresh current session, print summary and exit
# All done :)
