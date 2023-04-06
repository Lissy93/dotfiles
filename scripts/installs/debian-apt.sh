#!/usr/bin/env bash

################################################################
# 📜 Debian/ Ubuntu, apt Package Install / Update Script       #
################################################################
# Installs listed packages on Debian-based systems via apt-get #
# Also updates the cache database and existing applications    #
# Confirms apps aren't installed via different package manager #
# Doesn't include desktop apps, that're managed via Flatpak    #
# Apps are sorted by category, and arranged alphabetically     #
# Be sure to delete / comment out anything you do not need     #
# For more info, see: https://wiki.debian.org/Apt              #
################################################################
# MIT Licensed (C) Alicia Sykes 2023 <https://aliciasykes.com> #
################################################################

# Apps to be installed via apt-get
debian_apps=(
  # Essentials
  'git'           # Version controll
  'neovim'        # Text editor
  'ranger'        # Directory browser
  'tmux'          # Term multiplexer
  'wget'          # Download files

  # CLI Power Basics
  'aria2'         # Resuming download util (better wget)
  'bat'           # Output highlighting (better cat)
  'broot'         # Interactive directory navigation
  'ctags'         # Indexing of file info + headers
  'diff-so-fancy' # Readable file compares (better diff)
  'duf'           # Get info on mounted disks (better df)
  'exa'           # Listing files with info (better ls)
  'fzf'           # Fuzzy file finder and filtering
  'hyperfine'     # Benchmarking for arbitrary commands
  'just'          # Powerful command runner (better make)
  'jq'            # JSON parser, output and query files
  'most'          # Multi-window scroll pager (better less)
  'procs'         # Advanced process viewer (better ps)
  'ripgrep'       # Searching within files (better grep)
  'scrot'         # Screenshots programmatically via CLI
  'sd'            # RegEx find and replace (better sed)
  'thefuck'       # Auto-correct miss-typed commands
  'tealdeer'      # Reader for command docs (better man)
  'tree'          # Directory listings as tree structure
  'tokei'         # Count lines of code (better cloc)
  'trash-cli'     # Record and restore removed files
  'xsel'          # Copy paste access to the X clipboard
  'zoxide'        # Auto-learning navigation (better cd)

  # Security Utilities
  'clamav'        # Open source virus scanning suite
  'cryptsetup'    # Reading / writing encrypted volumes
  'gnupg'         # PGP encryption, signing and verifying
  'git-crypt'     # Transparent encryption for git repos
  'lynis'         # Scan system for common security issues
  'openssl'       # Cryptography and SSL/TLS Toolkit
  'rkhunter'      # Search / detect potential root kits

  # Monitoring, management and stats
  'btop'          # Live system resource monitoring
  'bmon'          # Bandwidth utilization monitor
  'ctop'          # Container metrics and monitoring
  'gping'         # Interactive ping tool, with graph
  'glances'       # Resource monitor + web and API
  'goaccess'      # Web log analyzer and viewer
  'speedtest-cli' # Command line speed test utility

  # CLI Fun
  'cowsay'        # Outputs message with ASCII art cow
  'figlet'        # Outputs text as 3D ASCII word art
  'lolcat'        # Rainbow colored terminal output
  'neofetch'      # Show off distro and system info
)

ubuntu_repos=(
  'main'
  'universe'
  'restricted'
  'multiverse'
)

debian_repos=(
  'main'
  'contrib'
)

# Following packages not found by apt, need to fix:
# aria2, bat, broot, diff-so-fancy, duf, hyperfine,
# just, procs, ripgrep, sd, tealdeer, tokei, trash-cli,
# zoxide, clamav, cryptsetup, gnupg, lynis, btop, gping.


# Colors
PURPLE='\033[0;35m'
YELLOW='\033[0;93m'
CYAN_B='\033[1;96m'
LIGHT='\x1b[2m'
RESET='\033[0m'

PROMPT_TIMEOUT=15 # When user is prompted for input, skip after x seconds

# If set to auto-yes - then don't wait for user reply
if [[ $* == *"--auto-yes"* ]]; then
  PROMPT_TIMEOUT=0
  REPLY='Y'
fi

# Print intro message
echo -e "${PURPLE}Starting Debian/ Ubuntu package install & update script"
echo -e "${YELLOW}Before proceeding, ensure your happy with all the packages listed in \e[4m${0##*/}"
echo -e "${RESET}"

# Check if running as root, and prompt for password if not
if [ "$EUID" -ne 0 ]; then
  echo -e "${PURPLE}Elevated permissions are required to adjust system settings."
  echo -e "${CYAN_B}Please enter your password...${RESET}"
  sudo -v
  if [ $? -eq 1 ]; then
    echo -e "${YELLOW}Exiting, as not being run as sudo${RESET}"
    exit 1
  fi
fi

# Check apt-get actually installed
if ! hash apt 2> /dev/null; then
  echo "${YELLOW_B}apt doesn't seem to be present on your system. Exiting...${RESET}"
  exit 1
fi

# Enable upstream package repositories
echo -e "${CYAN_B}Would you like to enable listed repos? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if ! hash add-apt-repository 2> /dev/null; then
    sudo apt install --reinstall software-properties-common
  fi
  # If Ubuntu, add Ubuntu repos
  if lsb_release -a 2>/dev/null | grep -q 'Ubuntu'; then
    for repo in ${ubuntu_repos[@]}; do
      echo -e "${PURPLE}Enabling ${repo} repo...${RESET}"
      sudo add-apt-repository $repo
    done
  else
    # Otherwise, add Debian repos
    for repo in ${debian_repos[@]}; do
      echo -e "${PURPLE}Enabling ${repo} repo...${RESET}"
      sudo add-apt-repository $repo
    done
  fi
fi

# Prompt user to update package database
echo -e "${CYAN_B}Would you like to update package database? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${PURPLE}Updating dadatbase...${RESET}"
  sudo apt update
fi

# Prompt user to upgrade currently installed packages
echo -e "${CYAN_B}Would you like to upgrade currently installed packages? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${PURPLE}Upgrading installed packages...${RESET}"
  sudo apt upgrade
fi

# Prompt user to clear old package caches
echo -e "${CYAN_B}Would you like to clear unused package caches? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${PURPLE}Freeing up disk space...${RESET}"
  sudo apt autoclean
fi

# Prompt user to install all listed apps
echo -e "${CYAN_B}Would you like to install listed apps? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${PURPLE}Starting install...${RESET}"
  for app in ${debian_apps[@]}; do
    if hash "${app}" 2> /dev/null; then
      echo -e "${YELLOW}[Skipping]${LIGHT} ${app} is already installed${RESET}"
    elif hash flatpak 2> /dev/null && [[ ! -z $(echo $(flatpak list --columns=ref | grep $app)) ]]; then
      echo -e "${YELLOW}[Skipping]${LIGHT} ${app} is already installed via Flatpak${RESET}"
    else
      echo -e "${PURPLE}[Installing]${LIGHT} Downloading ${app}...${RESET}"
      sudo apt install ${app} --assume-yes
    fi
  done
fi

echo -e "${PURPLE}Finished installing / updating Debian packages.${RESET}"

# EOF
