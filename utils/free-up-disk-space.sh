#!/usr/bin/env bash

######################################################################
# 📊 Free up disk space                                              #
######################################################################
# Series of commands for freeing up disk space on *nix based systems #
# Will ask for user permission before executing or deleting anything #
# Info about current disk usage and recommendations is printed prior #
# Tasks are split into 3 categories: recommended, optional, hardcore #
#                                                                    #
# Includes the following tasks:                                      #
# - Cleaning package cache for various package managers              #
# - Removing orphaned and unused packages and binaries               #
# - Setting logging preferences and removing old logs                #
# - Removing local cache files for the current user                  #
# - Deleting broken symlinks and empty files + folders               #
# - Finding and deleting duplicated large files                      #
#                                                                    #
# IMPORTANT: Before running, read through everything very carefully! #
# For docs and more info, see: https://github.com/lissy93/dotfiles   #
######################################################################
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
######################################################################

# Color Variables
CYAN_B='\033[1;96m'
YELLOW_B='\033[1;93m'
RED_B='\033[1;31m'
GREEN_B='\033[1;32m'
PLAIN_B='\033[1;37m'
RESET='\033[0m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
PURPLE_B='\033[1;35m'

# Herlper func, to check if a command exists
function fuds_command_exists () {
  command -v "$1" &> /dev/null
}

# Helper func, to check if a file or directory exists
function fuds_file_or_dir_exists () {
  [ -e "$1" ]
}

# Helper func, to detect if running on a Mac
function fuds_is_macos () {
  fuds_command_exists "sw_vers"
}

# Prints the title
function fuds_print_title () {
  echo -e "${CYAN_B}"
  if fuds_command_exists "figlet" ; then
    figlet "Free Up Disk Space"
  else
    echo "Free Up Disk Space"
  fi
  echo -e "${RESET}"
}

# Finds and outputs used, total and free disk space
function fuds_check_space () {
  diskMsg=$(df -H | awk '$NF=="/"{
  printf("You'\''re using %sB out of %sB total\n", $3, $2) }')
  diskMsg2=$(df -H | awk '$NF=="/"{ printf("There'\''s %sB of free space remaining\n", $4) }')
  echo -e "$PURPLE_B$diskMsg$PURPLE\n$diskMsg2$RESET"
}

function fuds_clean_pacman () {
  # Clean pacman cache
  sudo pacman -Scc
  # Remove orphaned packages
  sudo pacman -Rns $(pacman -Qtdq)
}

function fuds_clean_flatpak () {
  # Remove unused Flatpak packages
  flatpak uninstall --unused
  # Delete Flatpak package cache
  sudo rm -rfv /var/tmp/flatpak-cache-*
}

function fuds_clean_apt () {
  # Removes obsolete packages
  sudo apt autoremove
}

function fuds_remove_dead_snaps () {
  # Remove disabled snaps
  snap list --all | awk '/disabled/{print $1, $3}' |
  while read snapname revision; do
      snap remove "$snapname" --revision="$revision"
  done
}

function fuds_journal_configure () {
  # Limit size of journal logs to 0.5 GB
  journalctl --vacuum-size=500M
  # Limit age of journal logs to 1 month
  journalctl --vacuum-time=4weeks
}

function fuds_empty_trash () {
  # Delete the current users trash
  rm -rf ~/.local/share/Trash/*
}

function fuds_clear_caches () {
  # Remove thumbnails for file viewers
  rm -rf ~/.cache/thumbnails/*
}

function fuds_remove_duplicates () {
  # Find and prompt to delete duplicated files
  fdupes . -G 10 --size -S -n -t -d
}

function fuds_remove_broken () {
  # Remove broken symlinks
  find . -xtype l -delete
  # Remove empty files
  find . -type f -empty -delete
  # Remove empty folders
  find . -type d -empty -delete
}

function fuds_show_help () {
  fuds_print_title

  echo -e "${PURPLE_B}Free up disk space on *nix based systems\n"
  echo -e "Usage:${PURPLE} free-up-disk-space [OPTION]\n"
  echo -e "${PURPLE_B}Options:${PURPLE}"
  echo "  -h, --help    Show this help message"
  echo "  -r, --run     Run all tasks"
  echo "  -p, --pacman  Clean pacman cache and remove orphaned packages"
  echo "  -f, --flatpak Remove unused Flatpak packages and delete cache"
  echo "  -a, --apt     Remove obsolete packages"
  echo "  -s, --snaps   Remove disabled snaps"
  echo "  -j, --journal Configure journal logs"
  echo "  -t, --trash   Empty trash"
  echo "  -c, --caches  Remove thumbnails and other caches"
  echo "  -d, --dups    Find and delete duplicated files"
  echo "  -b, --broken  Remove broken symlinks and empty files + folders"
  echo ""
  echo -e "${PURPLE_B}Examples:${PURPLE}"
  echo "  free-up-disk-space"
  echo "  free-up-disk-space -p -f -a -s -j -t -c -d -b"
  echo "  free-up-disk-space --apt --snap --auto-yes"
  echo ""
  echo -e "${PURPLE_B}Note:"
  echo -e "  ${PURPLE}Some methods are not available for all operating systems"
  echo -e "  By default, it will automatically detect which options are available"
  echo -e "  You will be prompted before any changes are made (unless --auto-yes is used)${RESET}"
}

function free_up_disk_space () {

  # Print title
  fuds_print_title

  # Check available disk space
  fuds_check_space
  
  # Prompt to clean pacman cache
  if fuds_command_exists "pacman" ; then
    echo -e "\n${CYAN_B}Would you like to clean pacman cache? (y/N)${RESET}"
    read -n 1 -r ans_clean_pacman
    if [[ $ans_clean_pacman =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
      fuds_clean_pacman
    fi
  fi

  # Prompt to remove unused Flatpak packages
  if fuds_command_exists "flatpak" ; then
    echo -e "\n${CYAN_B}Would you like to remove unused Flatpak packages? (y/N)${RESET}"
    read -n 1 -r ans_clean_flatpak
    if [[ $ans_clean_flatpak =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
      fuds_clean_flatpak
    fi
  fi

  # Prompt to remove obsolete packages
  if fuds_command_exists "apt" ; then
    echo -e "\n${CYAN_B}Would you like to remove obsolete packages? (y/N)${RESET}"
    read -n 1 -r ans_clean_apt
    if [[ $ans_clean_apt =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
      fuds_clean_apt
    fi
  fi

  # Prompt to remove disabled snaps
  if fuds_command_exists "snap" ; then
    echo -e "\n${CYAN_B}Would you like to remove disabled snaps? (y/N)${RESET}"
    read -n 1 -r ans_remove_dead_snaps
    if [[ $ans_remove_dead_snaps =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
      fuds_remove_dead_snaps
    fi
  fi

  # Prompt to configure journal logs
  if fuds_command_exists "journalctl" ; then
    echo -e "\n${CYAN_B}Would you like to configure journal logs? (y/N)${RESET}"
    read -n 1 -r ans_journal_configure
    if [[ $ans_journal_configure =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
      fuds_journal_configure
    fi
  fi

  # Prompt to empty trash
  if fuds_file_or_dir_exists "$HOME/.local/share/Trash" ; then
    echo -e "\n${CYAN_B}Would you like to empty trash? (y/N)${RESET}"
    read -n 1 -r ans_empty_trash
    if [[ $ans_empty_trash =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
      fuds_empty_trash
    fi
  fi

  # Prompt to remove thumbnails and other caches
  if fuds_file_or_dir_exists "$HOME/.cache/thumbnails" ; then
    echo -e "\n${CYAN_B}Would you like to remove thumbnails and other caches? (y/N)${RESET}"
    read -n 1 -r ans_clear_caches
    if [[ $ans_clear_caches =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
      fuds_clear_caches
    fi
  fi

  # Prompt to find and delete duplicated files
  if fuds_command_exists "fdupes" ; then
    echo -e "\n${CYAN_B}Would you like to find and delete duplicated files? (y/N)${RESET}"
    read -n 1 -r ans_remove_duplicates
    if [[ $ans_remove_duplicates =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
      fuds_remove_duplicates
    fi
  fi

  # Prompt to remove broken symlinks and empty files + folders
  echo -e "\n${CYAN_B}Would you like to remove broken symlinks and empty files + folders? (y/N)${RESET}"
  read -n 1 -r ans_remove_broken
  if [[ $ans_remove_broken =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
    fuds_remove_broken
  fi
}

function fuds_start () {
    # Show help menu
  if [[ $@ == *"--help"* ]]; then
    fuds_show_help
  elif [ -z $@ ] || [[ $@ == *"--run"* ]] || [[ $@ == *"-r"* ]]; then
    # Begin the guided process
    free_up_disk_space
  else
    # Run specific tasks, based on which flags are present
    if [[ $@ == *"-p"* ]] || [[ $@ == *"--pacman"* ]];  then fuds_clean_pacman; fi
    if [[ $@ == *"-f"* ]] || [[ $@ == *"--flatpak"* ]]; then fuds_clean_flatpak; fi
    if [[ $@ == *"-a"* ]] || [[ $@ == *"--apt"* ]];     then fuds_clean_apt; fi
    if [[ $@ == *"-s"* ]] || [[ $@ == *"--snaps"* ]];   then fuds_remove_dead_snaps; fi
    if [[ $@ == *"-j"* ]] || [[ $@ == *"--journal"* ]]; then fuds_journal_configure; fi
    if [[ $@ == *"-t"* ]] || [[ $@ == *"--trash"* ]];   then fuds_empty_trash; fi
    if [[ $@ == *"-c"* ]] || [[ $@ == *"--caches"* ]];  then fuds_clear_caches; fi
    if [[ $@ == *"-d"* ]] || [[ $@ == *"--dups"* ]];    then fuds_remove_duplicates; fi
    if [[ $@ == *"-b"* ]] || [[ $@ == *"--broken"* ]];  then fuds_remove_broken; fi
  fi
  # New line and reset afterwards
  echo -e "\n${RESET}"
}

# Determine if file is being run directly or sourced
([[ -n $ZSH_EVAL_CONTEXT && $ZSH_EVAL_CONTEXT =~ :file$ ]] || 
  [[ -n $KSH_VERSION && $(cd "$(dirname -- "$0")" &&
    printf '%s' "${PWD%/}/")$(basename -- "$0") != "${.sh.file}" ]] || 
  [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)) && sourced=1 || sourced=0

# Either start now (if executed directly) or export the function (if sourced)
if [ $sourced -eq 0 ]; then
  fuds_start $@
else
  alias fuds='fuds_start $@'
  alias makespace='fuds_start $@'
  alias free-up-disk-space='fuds_start $@'
fi
