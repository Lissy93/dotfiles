#!/bin/bash

######################################################################
# 📊 Free up disk space                                              #
######################################################################
# Series of commands for freeing up disk space on *nix based systems #
# Will ask for user permission before executing or deleting anything #
# Info about current disk usage, and recomendations is printed prior #
# Tasks are split into 3 categories: recommended, optional, hardcore #
#                                                                    #
# Includes the following tasks:                                      #
# - Cleaning package cache for various package managers              #
# - Removing orphaned and unused packages and binaries               #
# - Setting logging preferences and removing old logs                #
# - Removing local cache files for the current user                  #
# - Deleting broken symlinks and empty files + folers                #
# - Finding and deleting duplicated large files                      #
#                                                                    #
# IMPORTANT: Before running, read through everything very carefully! #
# For docs and more info, see: https://github.com/lissy93/dotfiles   #
######################################################################
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
######################################################################

function fuds_check_space () {
  convert_to_gb() { echo "$(($1/1048576))" ; }
  storage_used="$(df --output=used / | tail -n 1)"
  storage_free="$(df --output=avail / | tail -n 1)"
  storage_total="$(($storage_used + $storage_free))"
  math_str="${storage_used} / ${storage_total} * 100"
  storage_percent="$(echo "${math_str}" |  bc -l)"
  echo "Disk ${storage_percent%%.*}% full"
  echo "You're using $(convert_to_gb $storage_used) GB out of $(convert_to_gb $storage_total) GB."\
  "($(convert_to_gb $storage_free) GB free)."
}

fuds_check_space

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
