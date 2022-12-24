#!/usr/bin/env bash

######################################################################
# Linux Desktop Application Installations via Flatpak                #
######################################################################
# This script will:                                                  #
# - Check that Flatpak is installed / promt to install               #
# - Update currently installed Flatpak apps from FlatHub             #
# - Check app not already installed via system package manager       #
# - Then install any not-yet-installed that are apps listed          #
#                                                                    #
# The following flag parameters are accepted:                        #
#   --prompt-before-each - Ask for user confirmation for each app    #
#   --dry-run - Run script, but without making changes to disk       #
#   --auto-yes - Don't prompt for any user input, use with care      #
#   --help - Print usage instructions / help menu, then exit         #
#                                                                    #
# IMPORTANT: Be sure to remove / comment any apps you do not want!   #
# For docs and more info, see: https://github.com/lissy93/dotfiles   #
######################################################################
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
######################################################################

# Remote origin to use for installations
flatpak_origin='flathub'

# List of desktop apps to be installed (specified by app ID)
flatpak_apps=(

  # Communication
  'com.discordapp.Discord'    # Team messaging and voice
  'im.riot.Riot'              # Decentralized Matrix chat
  'info.mumble.Mumble'        # Low latency VoIP client
  'org.jitsi.jitsi-meet'      # Encrypted video calls
  'org.mozilla.Thunderbird'   # Email + calendar client
  'org.signal.Signal'         # Private messenger, mobile
  'com.slack.Slack'           # Work and team messaging
  'com.github.eneshecan.WhatsAppForLinux' # WhatApp client

  # Media
  'com.spotify.Client'        # Music streaming
  'com.valvesoftware.Steam'   # Gaming
  'com.gitlab.newsflash'      # RSS reader
  'org.gnome.Cheese'          # Webcam client
  'org.libretro.RetroArch'    # Retro game emulation
  'org.videolan.VLC'          # Media player

  # Creativity
  'com.ultimaker.cura'        # 3D slicing
  'com.obsproject.Studio'     # Video streaming
  'com.transmissionbt.Transmission' # Torrent downloader
  'com.uploadedlobster.peek'  # Screen recorder
  'fr.handbrake.ghb'          # Video transcoder
  'nl.hjdskes.gcolor3'        # Color picker
  'org.audacityteam.Audacity' # Sound editor
  'org.blender.Blender'       # 3D modeling
  'org.darktable.Darktable'   # Video editor
  'org.flameshot.Flameshot'   # Screenshot tool
  'org.gimp.GIMP'             # Picture editor
  'org.inkscape.Inkscape'     # Vector editor
  'org.shotcut.Shotcut'       # Video editor
  'org.synfig.SynfigStudio'   # 2D animation

  # Software development
  'com.visualstudio.code'     # Extendable IDE
  'com.getpostman.Postman'    # API development
  'cc.arduino.IDE2'           # IOT development
  'com.axosoft.GitKraken'     # GUI git client
  'com.google.AndroidStudio'  # Android dev IDE
  'io.podman_desktop.PodmanDesktop' # Docker / Podman UI
  
  # Security testing
  'org.wireshark.Wireshark'   # Packet capture and analyzer
  'org.zaproxy.ZAP'           # Auto vulnerability scanning
  'org.nmap.Zenmap'           # GUI for Nmap security scans

  # Settings and system utils
  'com.borgbase.Vorta'        # Borg backup client

  # Browsers
  'org.mozilla.firefox'
  'com.github.Eloston.UngoogledChromium'
  'com.github.micahflee.torbrowser-launcher'

  # Office
  'org.libreoffice.LibreOffice' # Office suite
  'org.cvfosammmm.Setzer'       # LaTeX editor

  # Personal
  'ch.protonmail.protonmail-bridge' # ProtonMail bridge
  'com.belmoussaoui.Authenticator'  # OTP authenticator
  'org.cryptomator.Cryptomator'     # Encryption for cloud
  'org.standardnotes.standardnotes' # Encrypted synced notes
  'com.onepassword.OnePassword'     # Password manager
  # Missing: Trewsorit, EteSync, Veracrypt, Ledger
)

# Color Variables
CYAN_B='\033[1;96m'
YELLOW='\033[0;93m'
RED_B='\033[1;31m'
RESET='\033[0m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
LIGHT='\x1b[2m'

# Options
PROMPT_TIMEOUT=15 # When user is prompted for input, skip after x seconds
PARAMS=$* # User-specified parameters

if [[ $PARAMS == *"--auto-yes"* ]]; then
  PROMPT_TIMEOUT=1
  AUTO_YES=true
fi

# Helper function to install Flatpak (if not present) for users current distro
function install_flatpak () {
  # Arch, Manjaro
  if hash "pacman" 2> /dev/null; then
    echo -e "${PURPLE}Installing Flatpak via Pacman${RESET}"
    sudo pacman -S flatpak
  # Debian, Ubuntu, PopOS, Raspian
  elif hash "apt" 2> /dev/null; then
    echo -e "${PURPLE}Installing Flatpak via apt get${RESET}"
    sudo apt install flatpak
  # Alpine
  elif hash "apk" 2> /dev/null; then
    echo -e "${PURPLE}Installing Flatpak via apk add${RESET}"
    sudo apk add flatpak
  # Red Hat, CentOS
  elif hash "yum" 2> /dev/null; then
    echo -e "${PURPLE}Installing Flatpak via Yum${RESET}"
    sudo yum install flatpak
  fi
}

# Checks if a given app ($1) is already installed, otherwise installs it
function install_app () {
  app=$1

  # If --prompt-before-each is set, then ask user if they'd like to proceed
  if [[ $PARAMS == *"--prompt-before-each"* ]]; then
    echo -e -n "\n${CYAN_B}Would you like to install ${app}? (y/N) ${RESET}"
    read -t 15 -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ $AUTO_YES != true ]] ; then
      echo -e "\n${YELLOW}[Skipping] ${LIGHT}${app}, rejected by user${RESET}"
      return
    fi
    echo
  fi

  # Process app ID, and grep for it in system
  app_name=$(echo $app | rev | cut -d "." -f1 | rev)
  is_in_flatpak=$(echo $(flatpak list --columns=ref | grep $app))
  is_in_pacman=$(echo $(pacman -Qk $(echo $app_name | tr 'A-Z' 'a-z') 2> /dev/null ))
  is_in_apt=$(echo $(dpkg -s $(echo $app_name | tr 'A-Z' 'a-z') 2> /dev/null ))

  # Check app not already installed via Flatpak
  if [ -n "$is_in_flatpak" ]; then
    echo -e "${YELLOW}[Skipping] ${LIGHT}${app_name} is already installed.${RESET}"
  # Check app not installed via Pacman (Arch Linux)
  elif [[ "${is_in_pacman}" == *"total files"* ]]; then
    echo -e "${YELLOW}[Skipping] ${LIGHT}${app_name} is already installed via Pacman.${RESET}"
  # Check app not installed via apt get (Debian)
  elif [[ "${is_in_apt}" == *"install ok installed"* ]]; then
    echo -e "${YELLOW}[Skipping] ${LIGHT}${app_name} is already installed via apt-get.${RESET}"
  else
    # Install app using Flatpak
    echo -e "${GREEN}[Installing] ${LIGHT}Downloading ${app_name} (from ${flatpak_origin}).${RESET}"
    if [[ $PARAMS == *"--dry-run"* ]]; then return; fi # Skip if --dry-run enabled
    flatpak install -y --noninteractive $flatpak_origin $app
  fi
}

function print_usage () {
  echo -e "${CYAN_B}Flatpak Linux Desktop App Installation and Update script${RESET}"
  echo -e "${PURPLE}The following tasks will be completed:\n"\
  "- Check Flatpak is installed correctly / prompt to install if not\n"\
  "- Add the flathub repo, if not already present\n"\
  "- Upgrade Flatpak, and update all exiting installed apps\n"\
  "- Installs each app in the list (if not already present)\n"\
  "${RESET}"
}

# Show help menu
print_usage
if [[ $PARAMS == *"--help"* ]]; then exit; fi

# Ask user if they'd like to proceed, and exit if not
echo -e "${CYAN_B}Would you like to install Flatpak desktop apps? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ $AUTO_YES != true ]] ; then
  echo -e "${YELLOW}Skipping Flatpak installations..."
  exit 0
fi

echo -e "${CYAN_B}Starting Flatpak App Installation Script${RESET}"

# Check that Flatpak is present, prompt to install or exit if not
if ! hash flatpak 2> /dev/null; then
  echo -e "${PURPLE}Flatpak isn't yet installed on your system${RESET}"
  echo -e "${CYAN_B}Would you like to install Flatpak now?${RESET}\n"
  read -t $PROMPT_TIMEOUT -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
    install_flatpak
  else
    echo -e "${YELLOW}Skipping Flatpak installations, as Flatpack not installed"
    exit 0
  fi
fi

# Add FlatHub as upstream repo, if not already present
echo -e "${PURPLE}Adding Flathub repo${RESET}"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Update currently installed apps
echo -e "${PURPLE}Updating installed apps${RESET}"
flatpak update --assumeyes --noninteractive

# Install each app listed above (if not already installed)
echo -e "${PURPLE}Installing apps defined in manifest${RESET}"
for app in ${flatpak_apps[@]}; do
  install_app $app
done

echo -e "${PURPLE}Finished processing Flatpak apps${RESET}"
