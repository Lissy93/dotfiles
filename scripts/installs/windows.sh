#!/usr/bin/env bash

# Apps and packages to be installed on Windows systems
# Apps are sorted by category, and arranged alphabetically
# Be sure to delete / comment out anything you do not need

set -e

# Apps to be installed via Winget
winget_apps=(
  # Apps
  'Mozilla.Firefox'
  'StandardNotes.StandardNotes'
  'Mozilla.Thunderbird'
  'ProtonTechnologies.ProtonMailBridge'
  'AgileBits.1Password'
  'BraveSoftware.BraveBrowser'
  'LibreOffice.LibreOffice'
  'qBittorrent.qBittorrent'
  
  # Development
  'Microsoft.PowerToys'
  'Docker.DockerDesktop'
  'Oracle.VirtualBox'
  'WinSCP.WinSCP'
  'Postman.Postman'
  'Arduino.Arduino'
  'SQLiteBrowser.SQLiteBrowser'
  'Notepad++.Notepad++'

  # Utils
  'Lexikos.AutoHotkey'
  'REALiX.HWiNFO'
  'GNURadio.GNURadio'
  'Balena.Etcher'

  # Security Utils
  'Cryptomator.Cryptomator'
  'Keybase.Keybase'
  'KeePassXCTeam.KeePassXC'

  # Networking
  'WiresharkFoundation.Wireshark'
  'angryziber.AngryIPScanner'
  
  # Media + Creativity
  'Inkscape.Inkscape'
  'darktable.darktable'
  'Audacity.Audacity'
  'GIMP.GIMP'
  'VideoLAN.VLC'
  'OBSProject.OBSStudio'
  'Meltytech.Shotcut'
  'BlenderFoundation.Blender'
  'Ultimaker.Cura'
  'Spotify.Spotify'
  'Valve.Steam'
  'thehandbraketeam.handbrake'  
)

CYAN_B='\033[1;96m'
YELLOW_B='\033[1;93m'
RED_B='\033[1;31m'
GREEN_B='\033[1;32m'
RESET='\033[0m'

echo "${CYAN_B}Installing Windows Packages...${RESET}"

# Winget
if hash winget 2> /dev/null; then
  for app in ${winget_apps[@]}; do
    winget install --id=${app} -e
  done
else
  echo "${YELLOW_B}Winget not present, skipping${RESET}"
fi

