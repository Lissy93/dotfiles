#!/bin/bash

########################################################################
# Sets app preferences on Linux via dconf                              #
########################################################################
# Uses dconf to apply application preferences on Linux GNOME desktops  #
# Reads source files from ./config/gnome/*.dconf ($DCONF_SOURCE_DIR)   #
# Creates a backup of current settings, then loads + saves new config  #
# IMPORTANT: Be sure to read files through thoughouly before executing #
########################################################################
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com>   #
########################################################################

# Color variables
PRIMARY_COLOR='\033[1;34m'
ACCENT_COLOR='\033[0;96m'
ERROR_COLOR='\033[1;31m'
WARN_COLOR='\033[0;33m'
SUCCESS_COLOR='\033[0;32m'
RESET='\033[0m'
ITAL='\e[3m'
PALE='\e[2m'
UNDAL='\e[4m'

# Set config variables
PARAMS=$*
FILE_EXT='dconf'

show_help () {
  echo -e "${PRIMARY_COLOR}🐧 Linux Desktop Preferences${RESET_COLOR}\n"\
  "${ACCENT_COLOR}This script will apply preferences to the GNOME shell and"\
  "related applications using dconf\n Config files are read from"\
  "./config/gnome and applied to the dconf database in  ~/.config/dconf/[user]\n"\
  "Before any changes are made, existing settings are backed up to ~/.cache/dconf-backups/\n"\
  "\n The following applications will be configured:\n"\
  " - Terminal\n"\
  " - Calculator\n"\
  " - Evolution\n"\
  " - Geddit\n"\
  " - gThumb\n"\
  " - Todo App\n"\
  "\n${WARN_COLOR}⚠ Be sure that you've read and unserstood which"\
  "changes will be applied before proceeding${RESET}\n"
}

# If --help flag passed in, just show the help menu
if [[ $PARAMS == *"--help"* ]]; then
  show_help
  exit 0
elif [[ ! $PARAMS == *"--skip-intro"* ]]; then
  show_help
fi

# Ask for user confirmation before proceeding (if skip flag isn't passed)
if [[ ! $PARAMS == *"--yes-to-all"* ]]; then
  echo -e "\n${PRIMARY_COLOR}Would you like to proceed? (y/N)${RESET}"
  read -t 15 -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${ACCENT_COLOR}\nNo worries, nothing will be applied"\
    "- feel free to come back another time."
    echo -e "${PRIMARY_COLOR}Exiting...${RESET}"
    exit 0
  else
    echo -e "\n"
  fi
fi

# Check dconf is installed, exit with error if not
if ! hash dconf 2> /dev/null; then
  echo -e "${PRIMARY_COLOR}This script requires dconf to be installed${RESET}"
  echo -e "${ACCENT_COLOR}Exiting...${RESET}"
  exit
fi

# Ensure XDG variable for cache location is set
if [ -z ${XDG_CACHE_HOME+x} ]; then
  echo -e "${PRIMARY_COLOR}XDG_CACHE_HOME is not yet set. Will use ~/.cache${RESET}"
  XDG_CACHE_HOME="${HOME}/.cache"
fi

# Set locations for where to store backups, and where to read new configs from
DCONF_BACKUP_DIR="${DCONF_BACKUP_DIR:-${XDG_CACHE_HOME}/dconf-backups}"
DCONF_BACKUP_FILE=${DCONF_BACKUP_FILE:-"backup_"`date +"%Y-%m-%d_%H-%M-%S"`}
DCONF_SOURCE_DIR="${DOTFILES_DIR:-"$(cd "$(dirname "$0")" && pwd)/../.."}/config/gnome"

# Create directory to store backups
DCONF_BACKUP_PATH="${DCONF_BACKUP_DIR}/${DCONF_BACKUP_FILE}"
mkdir -p $DCONF_BACKUP_PATH

# For a given dconf key ($1), and specified file ($2), check info, make backup, apply settings
apply_dconf () {
  dconf_key=$1
  dconf_name=$2

  # If --prompt-before-each flag is set, then ask users permission for each app
  if [[ $PARAMS == *"--prompt-before-each"* ]]; then
    echo -e -n "\n${PRIMARY_COLOR}Would you like to apply ${dconf_name} settings? (y/N) ${RESET}"
    read -t 15 -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo -e "\n${ACCENT_COLOR}Skipping ${dconf_name} settings${RESET}"
      return
    fi
    echo
  fi

  # Check that a valid key is specified
  if [[ -z "$dconf_key" ]]; then
    echo -e "${ERROR_COLOR}⚠ Error, no key specified${RESET}"
    return
  fi

  # Check source file exists
  if [ ! -f "$DCONF_SOURCE_DIR/$dconf_name.$FILE_EXT" ]; then
    echo -e "${ERROR_COLOR}⚠ Error, the specified config file for"\
    "'${dconf_name}' doesn't exist in ${DCONF_SOURCE_DIR}${RESET}"
    return
  fi

  # Make backup of existing settings
  echo -e "${PRIMARY_COLOR}Applying ${dconf_name} config${RESET}"
  dconf dump $dconf_key > "${DCONF_BACKUP_PATH}/${dconf_name}.$FILE_EXT"

  # Apply new settings from file
  echo -e "${SUCCESS_COLOR}✓ ${dconf_name} settings succesfully applies to ${dconf_key}${RESET}"
  dconf load $dconf_key < $DCONF_SOURCE_DIR/${dconf_name}.$FILE_EXT
  
  # Print instructions on reverting changes
  echo -e "${ACCENT_COLOR}${ITAL}${PALE}To revert, run $"\
  "${UNDAL}dconf load $dconf_key < $DCONF_BACKUP_PATH/${dconf_name}.$FILE_EXT${RESET}\n"
}

# For the following dconf keys, apply settings in from the specified files
apply_dconf '/org/gnome/calculator/' 'calculator'   # Apply calculator settings
apply_dconf '/org/gnome/evolution/' 'evolution'     # Apply Evolution (mail client) settings
apply_dconf '/org/gnome/gedit/preferences/' 'gedit' # Apply Gedit (text editor) settings
apply_dconf '/org/gnome/gthumb/' 'gthumb'           # Apply gthumb (image editor) settings
apply_dconf '/org/gnome/todo/' 'todo'               # Apply todo list app settings
apply_dconf '/org/gnome/shell/extensions/' 'gnome-extensions'

# Run update command
echo -e "\n${PRIMARY_COLOR}Reloading dconf database${RESET}"
sudo dconf update
