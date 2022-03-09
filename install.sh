#!/usr/bin/env bash
# Bash script to setup or update my dotfiles
# For docs and dotfiles, see: https://github.com/lissy93/dotfiles
# Licensed under MIT - (C) Alicia Sykes, 2022 <https://aliciasykes.com>

# Paths and Settings
YADM_REPO_NAME="Lissy93/Dotfiles"
YADM_REPO="https://github.com/${YADM_REPO_NAME}.git"
# https://github.com/Lissy93/Dotfiles.git
# git@github.com:${YADM_REPO}.git
DOTFILES_DIR="/home/alicia/Documents/personal-projects/dotfiles"
# DOTFILES_DIR="~/dotfiles"
YADM_DATA="$HOME/.local/share/yadm"
BIN_PATH="$HOME/.local/bin"
YADM_BIN="$BIN_PATH/yadm"
TITLE='🧰 Lissy93/Dotfiles Setup'

# Color Variables
CYAN_B='\033[1;96m'
YELLOW_B='\033[1;93m'
RED_B='\033[1;31m'
GREEN_B='\033[1;32m'
PLAIN_B='\033[1;37m'
RESET='\033[0m'

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

# Displays death banner, and terminates app with exit code 1
terminate () {
  make_banner "Installation failed. Terminating..." ${RED_B}
  exit 1
}

# Checks if command / package (in $1) exists and then shows
# warning or error + terminates depending if required ($2)
system_verify () {
  if ! command_exists $1; then
    if $2; then
      echo -e "🚫 ${RED_B}Error:${PLAIN_B} $1 is not installed"
      terminate
    else
      echo -e "⚠️  ${YELLOW_B}Warning:${PLAIN_B} $1 is not installed"
    fi
  fi
}

# Show starting banner
make_banner "${TITLE}" "${CYAN_B}" 1

# Verify required packages are installed
system_verify "zsh" false
system_verify "vim" false
system_verify "git" true
system_verify "tmux" false
system_verify "yadm" false

# If on Mac, offer to install Brew
if [ "$system_type" = "Darwin" ] && ! command_exists brew; then
  read -p "Would you like to install Homebrew? (y/N)" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -en "🍺 ${YELLOW_B}Installing Homebrew...${RESET}\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

# Offer to install YADM if not setup
if ! command_exists yadm && ! [ -a "${YADM_BIN}" ]; then
  read -p "Install YDAM now? (y/N)" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command_exists brew && [ "$system_type" = "Darwin" ]; then
      brew install yadm
    else
      echo "Installing YADM into ${YADM_DATA}\n"
      git clone https://github.com/TheLocehiliosan/yadm.git $YADM_DATA
      mkdir -p $BIN_PATH; ln -s $YADM_DATA/yadm $YADM_BIN
    fi
  else
    echo "🚫 YDAM is required, exiting setup..." && exit 1
  fi
fi

# If YADM alias not set, then point it to yadm binary
if ! command_exists yadm; then
  shopt -s expand_aliases
  alias yadm=$YADM_BIN
fi

# Download / update dotfiles repo with YADM
if [[ ! -d "$DOTFILES_DIR" ]]
then
  echo "Dotfiles not yet present. Will download ${YADM_REPO_NAME} into ${DOTFILES_DIR}"
  mkdir -p "${DOTFILES_DIR}"
  cd "${DOTFILES_DIR}" && yadm clone ${YADM_REPO}
else
  echo -e "Pulling changes from ${YADM_REPO_NAME} into ${DOTFILES_DIR}"
  cd "${DOTFILES_DIR}" && yadm pull
fi

# If git clone / pull failed, then exit with error
ret=$?
if ! test "$ret" -eq 0
then
    echo >&2 "Failed to fetch dotfiels $ret"
    terminate
fi

# If on Mac, update Brew bundle
if [ "$system_type" = "Darwin" ] && command_exists brew && [ -f "$HOME/.Brewfile" ]
then
  echo "Updating homebrew bundle"
  brew bundle --global
fi

# Print success message, and time taken
total_time=$((`date +%s`-start_time))
make_banner "✨ Dotfiles configured succesfully in $total_time seconds" ${GREEN_B} 1
exit 0
