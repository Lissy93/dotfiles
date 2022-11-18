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
total_events=90

if [ ! "$(uname -s)" = "Darwin" ]; then
  echo -e "${PRIMARY_COLOR}Incompatible System${RESET_COLOR}"
  echo -e "${ACCENT_COLOR}This script is specific to Mac OS,\
  and only intended to be run on Darwin-based systems${RESET_COLOR}"
  echo -e "${ACCENT_COLOR}Exiting...${RESET_COLOR}"
  exit 1
fi

if [[ ! $params == *"--skip-intro"* ]]; then
  clear
  
  # Prints intro message
  echo -e "${PRIMARY_COLOR} MacOS App Preference Script${RESET_COLOR}"
  echo -e "${ACCENT_COLOR}Settings will be applied to the following apps:"
  echo -e " - Finder"
  echo -e " - Safari"
  echo -e " - Mail App"
  echo -e " - Terminal"
  echo -e " - Time Machine"
  echo -e " - Activity Monitor"
  echo -e " - Mac App Store"
  echo -e " - Photos App"
  echo -e " - Messages App"
  echo -e " - Chromium"
  echo -e " - Transmission"
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



##########
# Finder #
##########
log_section "Finder"

log_msg "Open new tabs to Home"
defaults write com.apple.finder NewWindowTarget -string "PfHm"

log_msg "Open new windows to file root"
defaults write com.apple.finder NewWindowTargetPath -string "file:///"

log_msg "Show hidden files"
defaults write com.apple.finder AppleShowAllFiles -bool true

log_msg "Show file extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

log_msg "Don't ask before emptying trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

log_msg "View all network locations"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

log_msg "Show the ~/Library folder"
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

log_msg "Show the /Volumes folder"
sudo chflags nohidden /Volumes

log_msg "Allow finder to be fully quitted with ⌘ + Q"
defaults write com.apple.finder QuitMenuItem -bool true

log_msg "Show the status bar in Finder"
defaults write com.apple.finder ShowStatusBar -bool true

log_msg "Show the path bar in finder"
defaults write com.apple.finder ShowPathbar -bool true

log_msg "Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

log_msg "Expand the General, Open and Privlages file info panes"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true


log_msg "Keep directories at top of search results"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

log_msg "Search current directory by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

log_msg "Don't show warning when changing extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

log_msg "Don't add .DS_Store to network drives"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

log_msg "Don't add .DS_Store to USB devices"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

log_msg "Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

log_msg "Open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true

log_msg "Open a new Finder window when a disk is mounted"
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

log_msg "Show item info"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

log_msg "Enable snap-to-grid for icons on the desktop and finder"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

log_msg "Set grid spacing for icons on the desktop and finder"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

log_msg "Set icon size on desktop and in finder"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist



########################################
# Safari & Webkit Privacy Enchanements #
########################################
log_section "Safari and Webkit"

log_msg "Don't send search history to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

log_msg "Allow using tab to highlight elements"
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

log_msg "Show full URL"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

log_msg "Set homepage"
defaults write com.apple.Safari HomePage -string "about:blank"

log_msg "Don't open downloaded files automatically"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

log_msg "Hide favorites bar"
defaults write com.apple.Safari ShowFavoritesBar -bool false

log_msg "Hide sidebar"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

log_msg "Disable thumbnail cache"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

log_msg "Enable debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

log_msg "Search feature matches any part of word"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

log_msg "Remove unneeded icons from bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

log_msg "Enable developer options"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

log_msg "Enable spell check"
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true

log_msg "Disable auto-correct"
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

log_msg "Disable auto-fill addressess"
defaults write com.apple.Safari AutoFillFromAddressBook -bool false

log_msg "Disable auto-fill passwords"
defaults write com.apple.Safari AutoFillPasswords -bool false

log_msg "Disable auto-fill credit cards"
defaults write com.apple.Safari AutoFillCreditCardData -bool false

log_msg "Disable auto-fill misc forms"
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

log_msg "Enable fraud warnings"
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

log_msg "Disable web plugins"
defaults write com.apple.Safari WebKitPluginsEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

log_msg "Disable Java"
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false

log_msg "Prevent pop-ups"
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

log_msg "Dissallow auto-play"
defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false

log_msg "Use Do not Track header"
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

log_msg "Auto-update Extensions"
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

##################
# Apple Mail App #
##################
log_section "Apple Mail App"

log_msg "Copy only email address, not name"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

log_msg "Use ⌘ + Enter shortcut to quick send emails"
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

log_msg "Display messages in thread mode"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"

log_msg "Sort messages by date"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

log_msg "Sort by newest to oldest"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"

log_msg "Disable inline attatchment viewing"
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

################
# Terminal App #
################
log_section "Terminal App"

log_msg "Set Terminal to only use UTF-8"
defaults write com.apple.terminal StringEncodings -array 4

log_msg "Enable secure entry for Terminal"
defaults write com.apple.terminal SecureKeyboardEntry -bool true

log_msg "Apply custom Terminal theme"
theme=$(<config/macos/alicia-term.terminal)
plutil -replace Window\ Settings.Alicia-Term -xml "$theme" ~/Library/Preferences/com.apple.Terminal.plist
defaults write com.apple.terminal 'Default Window Settings' -string Alicia-Term  
defaults write com.apple.terminal 'Startup Window Settings' -string Alicia-Term
echo 'tell application "Terminal" to set current settings of first window to settings set "Alicia-Term"' | osascript

###############################################################################
# Time Machine                                                                #
###############################################################################
log_section "Time Machine"

log_msg "Prevent Time Machine prompting to use new drive as backup"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

log_msg "Disable local Time Machine backups"
hash tmutil &> /dev/null && sudo tmutil disablelocal

###############################################################################
# Activity Monitor                                                            #
###############################################################################
log_section "Activity Monitor"

log_msg "Show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

log_msg "Visualize CPU usage in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5

log_msg "Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

log_msg "Sort results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###################
# Apple Mac Store #
###################
log_section "Apple Mac Store"

log_msg "Allow automatic update checks"
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

log_msg "Auto install criticial security updates"
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

log_msg "Enable the debug menu"
defaults write com.apple.appstore ShowDebugMenu -bool true

log_msg "Enable extra dev tools"
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

####################
# Apple Photos App #
####################
log_section "Apple Photos App"

log_msg "Prevent Photos from opening automatically when devices are plugged in"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

######################
# Apple Messages App #
######################
log_section "Apple Messages App"

log_msg "Disable automatic emoji substitution"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

log_msg "Disable smart quotes"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

#############################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility #
#############################################################
log_section "Address Book, Calendar, TextEdit"

log_msg "Enable the debug menu in Address Book"
defaults write com.apple.addressbook ABShowDebugMenu -bool true

log_msg "Enable Dashboard dev mode"
defaults write com.apple.dashboard devmode -bool true

log_msg "Use plaintext for new text documents"
defaults write com.apple.TextEdit RichText -int 0

log_msg "Use UTF-8 for opening text files"
defaults write com.apple.TextEdit PlainTextEncoding -int 4

log_msg "Use UTF-8 for saving text files"
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

log_msg "Enable the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

log_msg "Auto-play videos when opened with QuickTime Player"
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

########################################
# Google Chrome & Google Chrome Canary #
########################################
log_section "Chromium"

log_msg "Use the system-native print preview dialog"
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

log_msg "Expand the print dialog by default"
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

####################
# Transmission.app #
####################
log_section "Transmission"

log_msg "Store incomplete downloads in the Downloads/torrents dir"
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

log_msg "Store completed downloads in Downloads directory"
defaults write org.m0k.transmission DownloadLocationConstant -bool true

log_msg "Dont prompt for confirmation before downloading"
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false

log_msg "No confirmation before removing non-downloading transfers"
defaults write org.m0k.transmission CheckRemoveDownloading -bool true

log_msg "Trash original torrents"
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

log_msg "Hide the donate message"
defaults write org.m0k.transmission WarningDonate -bool false

log_msg "Hide the legal disclaimer"
defaults write org.m0k.transmission WarningLegal -bool false

log_msg "Set IP blocklists"
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true

log_msg "Randomize port on launch"
defaults write org.m0k.transmission RandomPort -bool true

#################################
# Restart affected applications #
#################################
log_section "Finishing Up"
log_msg "Restarting afffecting apps"
for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"Contacts" \
	"Finder" \
	"Mail" \
	"Messages" \
	"Photos" \
	"Safari" \
	"Terminal" \
	"iCal"; do
	killall "${app}" &> /dev/null
done

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
