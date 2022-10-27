#!/bin/bash

##############################################################################
# Security improvments for Mac OS systems                                    #
# Covers Siri, firewall, account security, connections and network protocols #
#                                                                            #
# CAUTION: This script will apply changes to your OS X system configuration  #
# Be sure to read it through carefully, and remove anything you don't want.  #
#                                                                            #
# Options:                                                                   #
#   --silent     - Don't log any status outputs                              #
#   --skip-intro - Skip the warning and intro section                        #
#   --yes-to-all - Don't ptompt user to agree to changes                     #
#                                                                            #
# Licensed under MIT -  (C) Alicia Sykes 2022 <https://aliciasykes.com>      #
##############################################################################

############################################################
# Initialize variables, check requirements, and print info #
############################################################

# Record start time
start_time=`date +%s`

# Get params
params="$params $*"

# Color variables
PRIMARY_COLOR='\033[1;33m'
ACCENT_COLOR='\033[0;34m'
INFO_COLOR='\033[0;30m'
INFO_COLOR_U='\033[4;30m'
SUCCESS_COLOR='\033[0;32m'
WARN_1='\033[1;31m'
WARN_2='\033[0;31m'
RESET_COLOR='\033[0m'

# Current and total taslks, used for progress updates
current_event=0
total_events=34

if [ ! "$(uname -s)" = "Darwin" ]; then
  echo -e "${PRIMARY_COLOR}Incompatible System${RESET_COLOR}"
  echo -e "${ACCENT_COLOR}This script is specific to Mac OS,\
  and only intended to be run on Darwin-based systems${RESET_COLOR}"
  echo -e "${ACCENT_COLOR}Exiting...${RESET_COLOR}"
  exit 1
fi

if [[ ! $params == *"--skip-intro"* ]]; then
  # Prints intro message
  echo -e "${PRIMARY_COLOR} MacOS Security Settings${RESET_COLOR}"
  echo -e "${ACCENT_COLOR}The following options will be applied:"
  echo -e " - Disabling Siri and voice feedback"
  echo -e " - Configures firewall for security"
  echo -e " - Apply login + screen security settings"
  echo -e " - Prevent unauthorised connections"
  echo -e " - Disable printer and sharing protocols"

  # Informs user what they're running, and cautions them to read first
  echo -e "\n${INFO_COLOR}You are running ${0} on\
  $(hostname -f | sed -e 's/^[^.]*\.//') as $(id -un)${RESET_COLOR}"
  echo -e "${WARN_1}IMPORTANT:${WARN_2} This script will make changes to your system."
  echo -e "${WARN_2}Ensure that you've read it through before continuing.${RESET_COLOR}"

  # Ask for user confirmation before proceeding (if skip flag isn't passed)
  if [[ ! $params == *"--yes-to-all"* ]]; then
    echo -e "\n${PRIMARY_COLOR}Would you like to proceed? (y/N)${RESET_COLOR}"
    read -t 15 -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo -e "${ACCENT_COLOR}\nNo worries, nothing will be applied - feel free to come back another time."
      echo -e "${PRIMARY_COLOR}Exiting...${RESET_COLOR}"
      exit 0
    fi
  fi
  
fi

# Check have got admin privilages
if [ "$EUID" -ne 0 ]; then
  echo -e "${ACCENT_COLOR}\nElevated permissions are required to adjust system settings."
  echo -e "${PRIMARY_COLOR}Please enter your password...${RESET_COLOR}"
  script_path=$([[ "$0" = /* ]] && echo "$0" || echo "$PWD/${0#./}")
  params="--skip-intro ${params}"
  sudo "$script_path" $params || (
    echo -e "${ACCENT_COLOR}Unable to continue without sudo permissions"
    echo -e "${PRIMARY_COLOR}Exiting...${RESET_COLOR}"
    exit 1
  )
  exit 0
fi

# Helper function to log progress to console
function log_msg () {
  current_event=$(($current_event + 1))
  if [[ ! $params == *"--silent"* ]]; then
    if (("$current_event" < 10 )); then sp='0'; else sp=''; fi
    echo -e "${PRIMARY_COLOR}[${sp}${current_event}/${total_events}] ${ACCENT_COLOR}${1}${INFO_COLOR}"
  fi
}

# Helper function to log section to console
function log_section () {
  if [[ ! $params == *"--silent"* ]]; then
    echo -e "${PRIMARY_COLOR}[INFO ] ${1}${INFO_COLOR}"
  fi
}

echo -e "\n${PRIMARY_COLOR}Starting...${RESET_COLOR}"

# Quit System Preferences before starting
osascript -e 'tell application "System Preferences" to quit'

# ######################################
# Disabling Siri and related features #
# ######################################
log_section "Disable Telemetry and Assistant Features"

# Disable Ask Siri
log_msg "Disable 'Ask Siri'"
defaults write com.apple.assistant.support 'Assistant Enabled' -bool false

#  Disable Siri voice feedback
log_msg "Disable Siri voice feedback"
defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3

# Disable Siri services (Siri and assistantd)
log_msg "Disable Siri services (Siri and assistantd)"
launchctl disable "user/$UID/com.apple.assistantd"
launchctl disable "gui/$UID/com.apple.assistantd"
sudo launchctl disable 'system/com.apple.assistantd'
launchctl disable "user/$UID/com.apple.Siri.agent"
launchctl disable "gui/$UID/com.apple.Siri.agent"
sudo launchctl disable 'system/com.apple.Siri.agent'
if [ $(/usr/bin/csrutil status | awk '/status/ {print $5}' | sed 's/\.$//') = "enabled" ]; then
    >&2 echo 'This script requires SIP to be disabled. Read more: \
    https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection'
fi

# Disable "Do you want to enable Siri?" pop-up
log_msg "Disable 'Do you want to enable Siri?' pop-up"
defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True

# Hide Siri from menu bar
log_msg "Hide Siri from menu bar"
defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0

# Hide Siri from status menu
log_msg "Hide Siri from status menu"
defaults write com.apple.Siri 'StatusMenuVisible' -bool false
defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true

# Opt-out from Siri data collection
log_msg "Opt-out from Siri data collection"
defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2

# Don't prompt user to report crashes, may leak sensitive info
log_msg "Disable crash reporter"
defaults write com.apple.CrashReporter DialogType none

############################
# MacOS Firefwall Security #
############################
log_section "Firewall Config"

# Prevent automatically allowing incoming connections to signed apps
log_msg "Prevent automatically allowing incoming connections to signed apps"
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false

# Prevent automatically allowing incoming connections to downloaded signed apps
log_msg "Prevent automatically allowing incoming connections to downloaded signed apps"
sudo defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool false

# Enable application firewall
log_msg "Enable application firewall"
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool true
defaults write com.apple.security.firewall EnableFirewall -bool true

# Turn on firewall logging
log_msg "Turn on firewall logging"
/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true

# Turn on stealth mode
log_msg "Turn on stealth mode"
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true
defaults write com.apple.security.firewall EnableStealthMode -bool true

# Will prompt user to allow network access even for signed apps
log_msg "Prevent signed apps from being automatically whitelisted"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off

# Will prompt user to allow network access for downloaded apps
log_msg "Prevent downloaded apps from being automatically whitelisted"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off

# Sending hangup command to socketfilterfw is required for changes to take effect
log_msg "Restarting socket filter firewall"
sudo pkill -HUP socketfilterfw

# Prevents quarantine from storing info about downloaded files as privacy risk
log_msg "Disabling GateKeeper"
sudo spctl --master-disable

####################################
# Log In and User Account Security #
####################################
log_section "Account Security"

# Enforce system hibernation
log_msg "Enforce hibernation instead of sleep"
sudo pmset -a destroyfvkeyonstandby 1

# Evict FileVault keys from memory
log_msg "Evict FileVault keys from memory on hibernate"
sudo pmset -a hibernatemode 25

# Set power settings (required when evicting FV keys)
log_msg "Disable power nap and other auto-power settings"
sudo pmset -a powernap 0
sudo pmset -a standby 0
sudo pmset -a standbydelay 0
sudo pmset -a autopoweroff 0

# Require a password to wake the computer from sleep or screen saver
log_msg "Require a password to wake the computer from sleep or screen saver"
sudo defaults write /Library/Preferences/com.apple.screensaver askForPassword -bool true

# Initiate session lock five seconds after screen saver is started
log_msg "Initiate session lock five seconds after screen saver is started"
sudo defaults write /Library/Preferences/com.apple.screensaver 'askForPasswordDelay' -int 5

# Disables signing in as Guest from the login screen
log_msg "Disables signing in as Guest from the login screen"
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO

# Disables Guest access to file shares over AF
log_msg "Disables Guest access to file shares over AF"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO


####################################
# Prevent Unauthorized Connections #
####################################
log_section "Prevent Unauthorized Connections"

# Disables Guest access to file shares over SMB
log_msg "Disables Guest access to file shares over SMB"
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO

# Disable remote login (incoming SSH and SFTP connections)
log_msg "Disable remote login (incoming SSH and SFTP connections)"
echo 'yes' | sudo systemsetup -setremotelogin off

# Disable insecure TFTP service
log_msg "Disable insecure TFTP service"
sudo launchctl disable 'system/com.apple.tftpd'

# Disable Bonjour multicast advertising
log_msg "Disable Bonjour multicast advertising"
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

# Disable insecure telnet protocol
log_msg "Disable insecure telnet protocol"
sudo launchctl disable system/com.apple.telnetd

log_msg "Prevent auto-launching captive portal webpages"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false

#########################################
# Disable Printers and Sharing Protocols #
#########################################
log_section "Printers and Sharing Protocols"

# Disable sharing of local printers with other computers
log_msg "Disable sharing of local printers with other computers"
cupsctl --no-share-printers

# Disable printing from any address including the Internet
log_msg "Disable printing from any address including the Internet"
cupsctl --no-remote-any

# Disable remote printer administration
log_msg "Disable remote printer administration"
cupsctl --no-remote-admin

# Disable Captive portal
log_msg "Disable Captive portal"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false

#####################################
# Print finishing message, and exit #
#####################################
echo -e "${PRIMARY_COLOR}\nFinishing...${RESET_COLOR}"
echo -e "${SUCCESS_COLOR}✔ ${current_event}/${total_events} tasks were completed \
succesfully in $((`date +%s`-start_time)) seconds${RESET_COLOR}"
echo -e "\n${PRIMARY_COLOR}         .:'\n     __ :'__\n  .'\`__\`-'__\`\`.\n \
:__________.-'\n :_________:\n  :_________\`-;\n   \`.__.-.__.'\n${RESET_COLOR}"

if [[ ! $params == *"--quick-exit"* ]]; then
  echo -e "${ACCENT_COLOR}Press any key to continue.${RESET_COLOR}"
  read -t 5 -n 1 -s
fi
exit 0
