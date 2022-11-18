#!/usr/bin/env bash

######################################################################
# 🧰 Lissy93/Dotfiles - All-in-One Install and Setup Script for Unix #
######################################################################
# Fetches latest changes, symlinks files, and installs dependencies  #
# Then sets up ZSH, TMUX, Vim as well as OS-specific tools and apps  #
# Checks all dependencies are met, and prompts to install if missing #
# For docs and more info, see: https://github.com/lissy93/dotfiles   #
#                                                                    #
# IMPORTANT: Before running, read through everything very carefully! #
#                                                                    #
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
######################################################################

# Set variables for reference
PARAMS=$* # User-specified parameters
CURRENT_DIR=$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)
SYSTEM_TYPE=$(uname -s) # Get system type - Linux / MacOS (Darwin)
PROMPT_TIMEOUT=15 # When user is prompted for input, skip after x seconds
START_TIME=`date +%s` # Start timer
SRC_DIR=$(dirname ${0})

# Dotfiles Source Repo and Destination Directory
REPO_NAME="${REPO_NAME:-Lissy93/Dotfiles}"
DOTFILES_DIR="${DOTFILES_DIR:-${SRC_DIR:-$HOME/.dotfiles}}"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/${REPO_NAME}.git}"

# Config Names and Locations
TITLE="🧰 ${REPO_NAME} Setup"
SYMLINK_FILE="${SYMLINK_FILE:-symlinks.yaml}"
DOTBOT_DIR="lib/dotbot"
DOTBOT_BIN="bin/dotbot"

# Color Variables
CYAN_B='\033[1;96m'
YELLOW_B='\033[1;93m'
RED_B='\033[1;31m'
GREEN_B='\033[1;32m'
PLAIN_B='\033[1;37m'
RESET='\033[0m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'

# Clear the screen
if [[ ! $PARAMS == *"--no-clear"* ]] && [[ ! $PARAMS == *"--help"* ]] ; then
  clear
fi

# If set to auto-yes - then don't wait for user reply
if [[ $PARAMS == *"--auto-yes"* ]]; then
  PROMPT_TIMEOUT=1
  AUTO_YES=true
fi

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
  echo -e "${CYAN_B}The seup script will do the following:${RESET}\n"\
  "${C2}(1) Pre-Setup Tasls\n"\
  "  ${C3}- Check that all requirements are met, and system is compatible\n"\
  "  ${C3}- Sets environmental variables from params, or uses sensible defaults\n"\
  "  ${C3}- Output welcome message and summary of changes\n"\
  "${C2}(2) Setup Dotfiles\n"\
  "  ${C3}- Clone or update dotfiles from git\n"\
  "  ${C3}- Symlinks dotfiles to correct locations\n"\
  "${C2}(3) Install packages\n"\
  "  ${C3}- On MacOS, prompt to install Homebrew if not present\n"\
  "  ${C3}- On MacOS, updates and installs apps liseted in Brewfile\n"\
  "  ${C3}- On Arch Linux, updates and installs packages via Pacman\n"\
  "  ${C3}- On Debian Linux, updates and installs packages via apt get\n"\
  "  ${C3}- On Linux desktop systems, prompt to install desktop apps via Flatpak\n"\
  "  ${C3}- Checks that OS is up-to-date and criticial patches are installed\n"\
  "${C2}(4) Configure sytstem\n"\
  "  ${C3}- Setup Vim, and install / update Vim plugins via Plug\n"\
  "  ${C3}- Setup Tmux, and install / update Tmux plugins via TPM\n"\
  "  ${C3}- Setup ZSH, and install / update ZSH plugins via Antigen\n"\
  "  ${C3}- Apply system settings (via NSDefaults on Mac, dconf on Linux)\n"\
  "  ${C3}- Apply assets, wallpaper, fonts, screensaver, etc\n"\
  "${C2}(5) Finishing Up\n"\
  "  ${C3}- Refresh current terminal session\n"\
  "  ${C3}- Print summary of applied changes and time taken\n"\
  "  ${C3}- Exit with appropriate status code\n\n"\
  "${PURPLE}You will be prompted at each stage, before any changes are made.${RESET}\n"\
  "${PURPLE}For more info, see GitHub: \033[4;35mhttps://github.com/${REPO_NAME}${RESET}"
}

# Cleanup tasks, run when the script exits
cleanup () {
  # Reset tab color and title (iTerm2 only)
  echo -e "\033];\007\033]6;1;bg;*;default\a"

  # Unset re-used variables
  unset PROMPT_TIMEOUT
  unset AUTO_YES

  # dinosaurs are awesome
  echo "🦖"
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

# Shows a desktop notification, on compatible systems ($1 = message)
show_notification () {
  if [[ $PARAMS == *"--no-notifications"* ]]; then return; fi
  notif_title=$TITLE
  notif_logo="${DOTFILES_DIR}/.github/logo.png"
  if command_exists terminal-notifier; then
    terminal-notifier -group 'dotfiles' -title $notif_title  -subtitle $1 \
    -message $2 -appIcon $notif_logo -contentImage $notif_logo \
    -remove 'ALL' -sound 'Sosumi' &> /dev/null
  elif command_exists notify-send; then
    notify-send -u normal -t 15000 -i "${notif_logo}" "${notif_title}" "${1}"
  fi
}

# Prints welcome banner, verifies that requirements are met
function pre_setup_tasks () {
  # Show pretty starting banner
  make_banner "${TITLE}" "${CYAN_B}" 1

  # Set term title
  echo -e "\033];${TITLE}\007\033]6;1;bg;red;brightness;30\a" \
  "\033]6;1;bg;green;brightness;235\a\033]6;1;bg;blue;brightness;215\a"

  # Print intro, listing what changes will be applied
  make_intro

  # Confirm that the user would like to proceed
  echo -e "\n${CYAN_B}Are you happy to continue? (y/N)${RESET}"
  read -t $PROMPT_TIMEOUT -n 1 -r ans_start
  if [[ ! $ans_start =~ ^[Yy]$ ]] && [[ $AUTO_YES != true ]] ; then
    echo -e "\n${PURPLE}No worries, feel free to come back another time."\
    "\nTerminating...${RESET}"
    make_banner "🚧 Installation Aborted" ${YELLOW_B} 1
    exit 0
  fi
  echo

  # If pre-requsite packages not found, prompt to install
  if ! command_exists git; then
    bash <(curl -s  -L 'https://alicia.url.lol/prerequisite-installs') $PARAMS
  fi

  # Verify required packages are installed
  system_verify "git" true
  system_verify "zsh" false
  system_verify "vim" false
  system_verify "nvim" false
  system_verify "tmux" false

  # If XDG variables arn't yet set, then configure defaults
  if [ -z ${XDG_CONFIG_HOME+x} ]; then
    echo -e "${YELLOW_B}XDG_CONFIG_HOME is not yet set. Will use ~/.config${RESET}"
    export XDG_CONFIG_HOME="${HOME}/.config"
  fi
  if [ -z ${XDG_DATA_HOME+x} ]; then
    echo -e "${YELLOW_B}XDG_DATA_HOME is not yet set. Will use ~/.local/share${RESET}"
    export XDG_DATA_HOME="${HOME}/.local/share"
  fi

  # Ensure dotfiles source directory is set and valid
  if [[ ! -d "$SRC_DIR" ]] && [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${YELLOW_B}Destination direcory not set,"\
    "defaulting to $HOME/.dotfiles\n"\
    "${CYAN_B}To specify where you'd like dotfiles to be downloaded to,"\
    "set the DOTFILES_DIR environmental variable, and re-run.${RESET}"
    DOTFILES_DIR="${HOME}/.dotfiles"
  fi
}

# Downloads / updates dotfiles and symlinks them
function setup_dot_files () {

  # If dotfiles not yet present, clone the repo
  if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${PURPLE}Dotfiles not yet present."\
    "Downloading ${REPO_NAME} into ${DOTFILES_DIR}${RESET}"
    echo -e "${YELLOW_B}You can change where dotfiles will be saved to,"\
    "by setting the DOTFILES_DIR env var${RESET}"
    mkdir -p "${DOTFILES_DIR}" && \
    git clone --recursive ${DOTFILES_REPO} ${DOTFILES_DIR} && \
    cd "${DOTFILES_DIR}"
  else # Dotfiles already downloaded, just fetch latest changes
    echo -e "${PURPLE}Pulling changes from ${REPO_NAME} into ${DOTFILES_DIR}${RESET}"
    cd "${DOTFILES_DIR}" && \
    git pull origin master && \
    echo -e "${PURPLE}Updating submodules${RESET}" && \
    git submodule update --recursive --remote --init
  fi

  # If git clone / pull failed, then exit with error
  if ! test "$?" -eq 0; then
    echo -e >&2 "${RED_B}Failed to fetch dotfiels from git${RESET}"
    terminate
  fi

  # Set up symlinks with dotbot
  echo -e "${PURPLE}Setting up Symlinks${RESET}"
  cd "${DOTFILES_DIR}"
  git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
  git submodule update --init --recursive "${DOTBOT_DIR}"
  chmod +x  lib/dotbot/bin/dotbot
  "${DOTFILES_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${DOTFILES_DIR}" -c "${SYMLINK_FILE}" "${@}"
}

# Applies application-specific preferences, and runs some setup tasks
function apply_preferences () {

  # If ZSH not the default shell, ask user if they'd like to set it
  if [[ $SHELL != *"zsh"* ]] && command_exists zsh; then
    echo -e "\n${CYAN_B}Would you like to set ZSH as your default shell? (y/N)${RESET}"
    read -t $PROMPT_TIMEOUT -n 1 -r ans_zsh
    if [[ $ans_zsh =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
      echo -e "${PURPLE}Setting ZSH as default shell${RESET}"
      chsh -s $(which zsh) $USER
    fi
  fi

  # Prompt user to update ZSH, Tmux and Vim plugins, then reload each
  echo -e "\n${CYAN_B}Would you like to install / update ZSH, Tmux and Vim plugins? (y/N)${RESET}"
  read -t $PROMPT_TIMEOUT -n 1 -r ans_cliplugins
  if [[ $ans_cliplugins =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
    # Install / update vim plugins with Plug
    echo -e "\n${PURPLE}Installing Vim Plugins${RESET}"
    vim +PlugInstall +qall

    # Install / update Tmux plugins with TPM
    echo -e "${PURPLE}Installing TMUX Plugins${RESET}"
    chmod ug+x "${XDG_DATA_HOME}/tmux/tpm"
    sh "${TMUX_PLUGIN_MANAGER_PATH}/tpm/bin/install_plugins"
    sh "${XDG_DATA_HOME}/tmux/plugins/tpm/bin/install_plugins"

    # Install / update ZSH plugins with Antigen
    echo -e "${PURPLE}Installing ZSH Plugins${RESET}"
    /bin/zsh -i -c "antigen update && antigen-apply"
  fi

  # Apply general system, app and OS security preferences (prompt user first)
  echo -e "\n${CYAN_B}Would you like to apply system preferences? (y/N)${RESET}"
  read -t $PROMPT_TIMEOUT -n 1 -r ans_syspref
  if [[ $ans_syspref =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]]; then
    if [ "$SYSTEM_TYPE" = "Darwin" ]; then
      echo -e "\n${PURPLE}Applying MacOS system preferences,\
      ensure you've understood before proceeding${RESET}\n"
      macos_settings_dir="$DOTFILES_DIR/scripts/macos-setup"
      for macScript in "macos-security.sh" "macos-preferences.sh" "macos-apps.sh"; do
        chmod +x $macos_settings_dir/$macScript && \
        $macos_settings_dir/$macScript --quick-exit --yes-to-all
      done
    else
      echo -e "\n${PURPLE}Applying preferences to GNOME apps, ensure you've understood before proceeding${RESET}\n"
      dconf_script="$DOTFILES_DIR/scripts/linux/dconf-prefs.sh"
      chmod +x $dconf_script && $dconf_script
    fi
  fi
}

# Setup Brew, install / update packages, organize launchpad and checks for macOS updates
function intall_macos_packages () {
  # Homebrew not installed, ask user if they'd like to download it now
  if ! command_exists brew; then
    echo -e "\n${CYAN_B}Would you like to install Homebrew? (y/N)${RESET}"
    read -t $PROMPT_TIMEOUT -n 1 -r ans_homebrewins
    if [[ $ans_homebrewins =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
      echo -en "🍺 ${PURPLE}Installing Homebrew...${RESET}\n"
      brew_url='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
      /bin/bash -c "$(curl -fsSL $brew_url)"
      export PATH=/opt/homebrew/bin:$PATH
    fi
  fi
  # Update / Install the Homebrew packages in ~/.Brewfile
  if command_exists brew && [ -f "$DOTFILES_DIR/scripts/installs/Brewfile" ]; then
    echo -e "\n${PURPLE}Updating homebrew and packages...${RESET}"
    brew update # Update Brew to latest version
    brew upgrade # Upgrade all installed casks
    brew bundle --global --file $HOME/.Brewfile # Install all listed Brew apps
    brew cleanup # Remove stale lock files and outdated downloads
    killall Finder # Restart finder (required for some apps)
  else
    echo -e "${PURPLE}Skipping Homebrew as requirements not met${RESET}"
  fi
  # Restore launchpad structure with lporg
  launchpad_layout="${DOTFILES_DIR}/config/macos/launchpad.yml"
  if command_exists lporg && [ -f $launchpad_layout ]; then
    echo -e "\n${CYAN_B}Would you like to restore launchpad layout? (y/N)${RESET}"
    read -t $PROMPT_TIMEOUT -n 1 -r ans_restorelayout
    if [[ $ans_restorelayout =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
      echo -e "${PURPLE}Restoring Launchpad Layout...${RESET}"
      yes "" | lporg load $launchpad_layout
    fi
  fi
  # Check for MacOS software updates, and ask user if they'd like to install
  echo -e "\n${CYAN_B}Would you like to check for OX X system updates? (y/N)${RESET}"
  read -t $PROMPT_TIMEOUT -n 1 -r ans_macoscheck
  if [[ $ans_macoscheck =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
    echo -e "${PURPLE}Checking for software updates...${RESET}"
    pending_updates=$(softwareupdate -l 2>&1)
    if [[ ! $pending_updates == *"No new software available."* ]]; then
      echo -e "${PURPLE}A new version of Mac OS is availbile${RESET}"
      echo -e "${CYAN_B}Would you like to update to the latest version of MacOS? (y/N)${RESET}"
      read -t $PROMPT_TIMEOUT -n 1 -r ans_macosupdate
      if [[ $ans_macosupdate =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]]; then
        echo -e "${PURPLE}Updating MacOS${RESET}"
        softwareupdate -i -a
      fi
    else
      echo -e "${GREEN}System is up-to-date."\
      "Running $(sw_vers -productName) version $(sw_vers -productVersion)${RESET}"
    fi
  fi
}

# Based on system type, uses appropriate package manager to install / updates apps
function install_packages () {
  echo -e "\n${CYAN_B}Would you like to install / update system packages? (y/N)${RESET}"
  read -t $PROMPT_TIMEOUT -n 1 -r ans_syspackages
  if [[ ! $ans_syspackages =~ ^[Yy]$ ]] && [[ $AUTO_YES != true ]] ; then
    echo -e "\n${PURPLE}Skipping package installs${RESET}"
    return
  fi
  if [ "$SYSTEM_TYPE" = "Darwin" ]; then
    # Mac OS
    intall_macos_packages
  elif [ -f "/etc/arch-release" ]; then
    # Arch Linux
    arch_pkg_install_script="${DOTFILES_DIR}/scripts/installs/arch-pacman.sh"
    chmod +x $arch_pkg_install_script
    $arch_pkg_install_script $PARAMS
  fi
  # If running in Linux desktop mode, prompt to install desktop apps via Flatpak
  flatpak_script="${DOTFILES_DIR}/scripts/installs/flatpak.sh"
  if [[ $SYSTEM_TYPE == "Linux" ]] && [ ! -z $XDG_CURRENT_DESKTOP ] && [ -f $flatpak_script ]; then
    chmod +x $flatpak_script
    $flatpak_script $PARAMS
  fi
}

# Updates current session, and outputs summary
function finishing_up () {
  # Update source to ZSH entry point
  source "${HOME}/.zshenv"

  # Calculate time taken
  total_time=$((`date +%s`-START_TIME))
  if [[ $total_time -gt 60 ]]; then
    total_time="$(($total_time/60)) minutes"
  else
    total_time="${total_time} seconds"
  fi

  # Print success msg and pretty picture
  make_banner "✨ Dotfiles configured succesfully in $total_time" ${GREEN_B} 1
  echo -e "\033[0;92m     .--.\n    |o_o |\n    |:_/ |\n   // \
  \ \\ \n  (|     | ) \n /'\_   _/\`\\ \n \\___)=(___/\n"

  # Refresh ZSH sesssion
  SKIP_WELCOME=true || exec zsh

  # Show popup
  if command_exists terminal-notifier; then
    terminal-notifier -group 'dotfiles' -title $TITLE  -subtitle 'All Tasks Complete' \
    -message "Your dotfiles are now configured and ready to use 🥳" \
    -appIcon ./.github/logo.png -contentImage ./.github/logo.png \
    -remove 'ALL' -sound 'Sosumi' &> /dev/null
  fi

  # Show press any key to exit
  echo -e "${CYAN_B}Press any key to exit.${RESET}\n"
  read -t $PROMPT_TIMEOUT -n 1 -s

  # Bye
  exit 0
}

# Trigger cleanup on exit
trap cleanup EXIT

# If --help flag passed in, just show the help menu
if [[ $PARAMS == *"--help"* ]]; then
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
