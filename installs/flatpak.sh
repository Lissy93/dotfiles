#!/usr/bin/env bash



# Desktop apps to be installed via Flatpak
flatpak_apps=(

  # Communication
  'com.discordapp.Discord'    # Team messaging and voice
  'org.jitsi.jitsi-meet'      # Encrypted video calls
  'org.signal.Signal'         # Private messenger, mobile
  'info.mumble.Mumble'        # Low latency VoIP client
  'im.riot.Riot'              # Decentralized Matrix chat
  'org.mozilla.Thunderbird'   # Email + calendar client
  'com.github.eneshecan.WhatsAppForLinux' # WhatApp client

  # Media
  'org.videolan.VLC'          # Media player
  'com.obsproject.Studio'     # Video streaming
  'com.valvesoftware.Steam'   # Gaming
  'com.spotify.Client'        # Music streaming
  'org.gnome.Cheese'          # Webcam client

  # Creativity
  'org.inkscape.Inkscape'     # Vector editor
  'org.gimp.GIMP'             # Picture editor
  'org.darktable.Darktable'   # Video editor
  'org.audacityteam.Audacity' # Sound editor
  'org.shotcut.Shotcut'       # Video editor
  'org.blender.Blender'       # 3D modeling
  'com.ultimaker.cura'        # 3D slicing
  'fr.handbrake.ghb'          # Video transcoder
  'org.synfig.SynfigStudio'   # 2D animation
  'io.github.seadve.Kooha'    # Screen recorder

  # Software development
  'com.visualstudio.code'     # Extendable IDE
  'com.getpostman.Postman'    # API development
  'com.axosoft.GitKraken'     # GUI git client
  'cc.arduino.IDE2'           # IOT development
  'com.google.AndroidStudio'  # Android dev IDE

  # Security testing
  'org.wireshark.Wireshark'   # Packet capture and analyzer
  'org.zaproxy.ZAP'           # Auto vulnerability scanning
  'org.nmap.Zenmap'           # GUI for Nmap security scans

  # Browsers
  'org.mozilla.firefox'
  'com.github.Eloston.UngoogledChromium'

  # Personal
  'ch.protonmail.protonmail-bridge' # ProtonMail bridge
  'org.standardnotes.standardnotes' # Encrypted synced notes
  'com.belmoussaoui.Authenticator'  # OTP authenticator
  'org.cryptomator.Cryptomator'     # Encryption for cloud
  # Missing: Trewsorit, 1Password, EteSync, Veracrypt
)


CYAN_B='\033[1;96m'
YELLOW_B='\033[1;93m'
RED_B='\033[1;31m'
GREEN_B='\033[1;32m'
RESET='\033[0m'

echo -e "${CYAN_B}Installing Desktop Apps via Flatpak...${RESET}"

# Flatpak

# Pacman
if hash flatpak 2> /dev/null; then
  echo -e "${CYAN_B}Updating installed apps${RESET}"
  flatpak update
  for app in ${flatpak_apps[@]}; do
    # If pacman -Qk ${app}
    # And If: flatpak list --columns=ref | grep 'ch.protonmail.protonmail-bridge'
    pacman -S ${app}
  done
else
  echo "${YELLOW_B}Flatpak not present, skipping${RESET}"
fi
