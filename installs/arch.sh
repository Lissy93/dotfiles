#!/usr/bin/env bash

# List of packages to be installed on Arch-based systems
# Desktop apps installed via Flatpak, PKGBUILDs via Pacman
# Apps are sorted by category, and arranged alphabetically
# Be sure to delete / comment out anything you do not need

set -e

# Apps to be installed via Pacman
pacman_apps=(
  # Apps
  
  
  # Development
  

  # Utils

  # Security Utils


  # Netowking


)



CYAN_B='\033[1;96m'
YELLOW_B='\033[1;93m'
RED_B='\033[1;31m'
GREEN_B='\033[1;32m'
RESET='\033[0m'

echo "${CYAN_B}Installing Arch Packages...${RESET}"

# Pacman
if hash pacman 2> /dev/null; then
  for app in ${pacman_apps[@]}; do
    # If pacman -Qk ${app}
    # And If: flatpak list --columns=ref | grep 'ch.protonmail.protonmail-bridge'
    pacman -S ${app}
  done
else
  echo "${YELLOW_B}Pacman not present, skipping${RESET}"
fi

