#!/bin/bash

##############################################################################
# Applies MacOS settings and preferences in /Library/Preferences             #
# Covers Spotlight, layout, colors, fonts, mouse, keyboard and shortcuts     #
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
total_events=70

# Check system is compatible
if [ ! "$(uname -s)" = "Darwin" ]; then
  echo -e "${PRIMARY_COLOR}Incompatible System${RESET_COLOR}"
  echo -e "${ACCENT_COLOR}This script is specific to Mac OS,\
  and only intended to be run on Darwin-based systems${RESET_COLOR}"
  echo -e "${ACCENT_COLOR}Exiting...${RESET_COLOR}"
  exit 1
fi

# Print info, and prompt for confrimation
if [[ ! $params == *"--skip-intro"* ]]; then
  # Output what stuff will be updated
  echo -e "${PRIMARY_COLOR} MacOS User Preferences${RESET_COLOR}"
  echo -e "${ACCENT_COLOR}The following sections will be executed:"
  echo -e " - Device info"
  echo -e " - Localization"
  echo -e " - UI Settings"
  echo -e " - Opening, saving and printing files"
  echo -e " - System power and lock screen options"
  echo -e " - Sound and display quality"
  echo -e " - Keyboard and input"
  echo -e " - Mouse and trackpad"
  echo -e " - Spotlight and search"
  echo -e " - Dock and Launchpad"

  # Inform user what they're running, and cautions them to read first
  echo -e "\n${INFO_COLOR}You are running ${0} on\
  $(hostname -f | sed -e 's/^[^.]*\.//') as $(id -un)${RESET_COLOR}"
  echo -e "${WARN_1}IMPORTANT:${WARN_2} This script will make changes to your system.\
  Ensure you've read it through before continuing${RESET_COLOR}"

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

# Vzariables for system preferences
COMPUTER_NAME="AS-AND-MacBook"
HIGHLIGHT_COLOR="0 0.8 0.7"

# Quit System Preferences before starting
osascript -e 'tell application "System Preferences" to quit'

# Keep script alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###################
# Set Device Info #
###################
log_section "Device Info"

# Set computer name and hostname
log_msg "Set computer name"
sudo scutil --set ComputerName "$COMPUTER_NAME"

log_msg "Set remote hostname"
sudo scutil --set HostName "$COMPUTER_NAME"

log_msg "Set local hostname"
sudo scutil --set LocalHostName "$COMPUTER_NAME"

log_msg "Set SMB hostname"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"

############################
# Location and locale info #
############################
log_section "Local Preferences"

log_msg "Set language to English"
defaults write NSGlobalDomain AppleLanguages -array "en"

log_msg "Set locale to British"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=GBP"

log_msg "Set time zone to London"
sudo systemsetup -settimezone "Europe/London" > /dev/null

log_msg "Set units to metric"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

###############
# UI Settings #
###############
log_section "UI Settings"

# Set highlight color
log_msg "Set text highlight color"
defaults write NSGlobalDomain AppleHighlightColor -string "${HIGHLIGHT_COLOR}"

##################
# File Locations #
##################
log_section "File Locations"

log_msg "Set location to save screenshots to"
defaults write com.apple.screencapture location -string "${HOME}/Downloads/screenshots"

log_msg "Save screenshots in .png format"
defaults write com.apple.screencapture type -string "png"

###############################################
# Saving, Opening, Printing and Viewing Files #
###############################################
log_section "Opening, Saving and Printing Files"

log_msg "Set scrollbar to always show"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

log_msg "Set sidebar icon size to medium"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

log_msg "Set toolbar title rollover delay"
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0

log_msg "Set increased window resize speed"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.05

log_msg "Set file save dialog to expand to all files by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

log_msg "Set print dialog to expand to show all by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

log_msg "Set files to save to disk, not iCloud by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

log_msg "Set printer app to quit once job is completed"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

log_msg "Disables the app opening confirmation dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

log_msg "Remove duplicates in the Open With menu"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
-kill -r -domain local -domain system -domain user

log_msg "Show ASCII control characters using caret notation in text views"
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true 

#####################################
# System Power, Resuming, Lock, etc #
#####################################
log_section "System Power and Lock Screen"

log_msg "Disable waking on lid opening"
sudo pmset -a lidwake 1

log_msg "Prevent automatic restart when power restored"
sudo pmset -a autorestart 1

log_msg "Set display to sleep after 15 minutes"
sudo pmset -a displaysleep 15

log_msg "Set sysyem sleep time to 30 minutes when on battery"
sudo pmset -b sleep 30

log_msg "Set system to not sleep automatically when on mains power"
sudo pmset -c sleep 0

log_msg "Require password immediatley after sleep or screensaver"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

log_msg "Disable system wide resuming of windows"
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

log_msg "Disable auto termination of inactive apps"
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

log_msg "Disable the crash reporter"
defaults write com.apple.CrashReporter DialogType -string "none"

log_msg "Add host info to the login screen"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

##############################
# Sound and Display Settings #
##############################
log_section "Sound and Display"

log_msg "Increase sound quality for Bluetooth devivces"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

log_msg "Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 1

log_msg "Enable HiDPI display modes"
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

########################
# Keyboard, Text Input #
########################
log_section "Keyboard and Input"

log_msg "Disable automatic text capitalization"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

log_msg "Disable automatic dash substitution"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

log_msg "Disable automatic periord substitution"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

log_msg "Disable automatic period substitution"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

log_msg "Disable automatic spell correction"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

log_msg "Enable full keyboard navigation in all windows"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

log_msg "Allow modifier key to be used for mouse zooming"
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

log_msg "Follow the keyboard focus while zoomed in"
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

log_msg "Set time before keys start repeating"
defaults write NSGlobalDomain InitialKeyRepeat -int 50

log_msg "Set super fast key repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 8

log_msg "Fix UTF-8 bug in QuickLook"
echo "0x08000100:0" > ~/.CFUserTextEncoding

#####################################
# Mouse, Trackpad, Pointing Devices #
#####################################
log_section "Mouse and Trackpad"

log_msg "Enable tap to click for trackpad"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

log_msg "Enable tab to click for current user"
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

log_msg "Enable tap to click for the login screen"
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

log_msg "Set hot corners for trackpad"
defaults write com.apple.dock wvous-tl-corner -int 11
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 2
defaults write com.apple.dock wvous-bl-modifier -int 1048576
defaults write com.apple.dock wvous-br-corner -int 5
defaults write com.apple.dock wvous-br-modifier -int 1048576
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0

# ##############################
# Spotlight Search Preferences #
# ##############################
log_section "Spotlight and Search"

# Emable / disable search locations, and indexing order
log_msg "Set Spotlight Search Locations Order"
defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
	'{"enabled" = 1;"name" = "PDF";}' \
	'{"enabled" = 0;"name" = "FONTS";}' \
	'{"enabled" = 0;"name" = "DOCUMENTS";}' \
	'{"enabled" = 0;"name" = "MESSAGES";}' \
	'{"enabled" = 0;"name" = "CONTACT";}' \
	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
	'{"enabled" = 0;"name" = "IMAGES";}' \
	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
	'{"enabled" = 0;"name" = "MUSIC";}' \
	'{"enabled" = 0;"name" = "MOVIES";}' \
	'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 0;"name" = "SOURCE";}' \
	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
	'{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
	'{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
	'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

# Spotlight - load new settings, enable indexing, and rebuild index
log_msg "Refreshing Spotlight"
killall mds > /dev/null 2>&1
sudo mdutil -i on / > /dev/null
sudo mdutil -E / > /dev/null

###############################
# Dock and Launchpad Settings #
###############################
log_section "Dock and Launchpad"

log_msg "Set dock position to left-hand side"
defaults write com.apple.dock orientation left

log_msg "Remove default apps from the dock"
defaults write com.apple.dock persistent-apps -array

log_msg "Add highlight effect to dock stacks"
defaults write com.apple.dock mouse-over-hilite-stack -bool true

log_msg "Set item size within dock stacks"
defaults write com.apple.dock tilesize -int 48

log_msg "Set dock to use genie animation"
defaults write com.apple.dock mineffect -string "genie"

log_msg "Set apps to minimize into their dock icon"
defaults write com.apple.dock minimize-to-application -bool true

log_msg "Enable spring loading, for opening files by dragging to dock"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

log_msg "Enable process indicator for apps within dock"
defaults write com.apple.dock show-process-indicators -bool true

log_msg "Enable app launching animations"
defaults write com.apple.dock launchanim -bool true

log_msg "Set opening animation speed"
defaults write com.apple.dock expose-animation-duration -float 1

log_msg "Disable auntomatic rearanging of spaces"
defaults write com.apple.dock mru-spaces -bool false

log_msg "Set dock to auto-hide by default"
defaults write com.apple.dock autohide -bool true

log_msg "Set the dock's auto-hide delay to fast"
defaults write com.apple.dock autohide-delay -float 0.05

log_msg "Set the dock show / hide animation time"
defaults write com.apple.dock autohide-time-modifier -float 0.25

log_msg "Show which dock apps are hidden"
defaults write com.apple.dock showhidden -bool true

log_msg "Hide recent files from the dock"
defaults write com.apple.dock show-recents -bool false

# If DockUtil installed, then use it to remove default dock items, and add useful ones
if hash dockutil 2> /dev/null; then
  apps_to_remove_from_dock=(
    'App Store'  'Calendar' 'Contacts' 'FaceTime'
    'Keynote' 'Mail' 'Maps' 'Messages' 'Music'
    'News' 'Notes' 'Numbers'
    'Pages' 'Photos' 'Podcasts'
    'Reminders' 'TV'
  )
  apps_to_add_to_dock=(
    'iTerm' 'Firefox' 'Standard Notes' 'Visual Studio Code'
  )
  IFS=""
  # Removes useless apps from dock
  for app in ${apps_to_remove_from_dock[@]}; do
    dockutil --remove ~/Applications/${app}.app
  done
  # Adds useful apps to dock, if installed
  for app in ${apps_to_add_to_dock[@]}; do
    if [[ -d "~/Applications/${app}.app" ]]; then
      dockutil --add ~/Applications/${app}.app
    fi
  done
fi

log_msg "Add iOS Simulator to Launchpad"
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"

log_msg "Add Apple Watch simulator to Launchpad"
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"

log_msg "Restarting dock"
killall Dock

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
