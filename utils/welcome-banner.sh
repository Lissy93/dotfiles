#!/bin/bash

######################################################################
# 🌞 Welcome Banner                                                  #
######################################################################
# Prints personal greeting, system info and data about today         #
# Intended for use as a MOTD, for when using multiple systems        #
# For docs and more info, see: https://github.com/lissy93/dotfiles   #
#                                                                    #
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
######################################################################

# Formatting variables
COLOR_P='\033[1;36m'
COLOR_S='\033[0;36m'
RESET='\033[0m'

# Print time-based personalized message, using figlet & lolcat if availible
function welcome_greeting () {
  h=`date +%H`
  if [ $h -lt 04 ] || [[ $h -gt 22 ]];
    then greeting="Good Night"
  elif [ $h -lt 12 ];
    then greeting="Good morning"
  elif [ $h -lt 18 ];
    then greeting="Good afternoon"
  elif [ $h -lt 22 ];
    then greeting="Good evening"
  else
    greeting="Hello"
  fi
  WELCOME_MSG="$greeting $USER!"
  if hash lolcat 2>/dev/null && hash figlet 2>/dev/null; then
    echo "${WELCOME_MSG}" | figlet | lolcat
  else
    echo -e "$COLOR_P${WELCOME_MSG}${RESET}\n"
  fi
}

# Print system information with neofetch, if it's installed
function welcome_sysinfo () {
  if hash neofetch 2>/dev/null; then
    neofetch --shell_version off \
      --disable shell resolution de wm wm_theme theme icons terminal \
      --backend off \
      --colors 4 8 4 4 8 6 \
      --color_blocks off \
      --memory_display info
  fi
}

# Print todays info: Date, IP, weather, etc
function welcome_today () {
  timeout=0.5
  echo -e "\033[1;34mToday\n------"

  # Print date time
  echo -e "$COLOR_S$(date '+🗓️  Date: %A, %B %d, %Y at %H:%M')"

  # Print local weather
  curl -s -m $timeout "wttr.in?format=%cWeather:+%C+%t,+%p+%w"
  echo -e "${RESET}"

  # Print IP address
  if hash ip 2>/dev/null; then
    ip_address=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
    ip_interface=$(ip route get 8.8.8.8 | awk -F"dev " 'NR==1{split($2,a," ");print a[1]}')
    echo -e "${COLOR_S}🌐 IP: $(curl -s -m $timeout 'https://ipinfo.io/ip') (${ip_address} on ${ip_interface})"
    echo -e "${RESET}\n"
  fi
}

# Putting it all together
function welcome() {
  welcome_greeting
  welcome_sysinfo
  welcome_today
}

# Determine if file is being run directly or sourced
([[ -n $ZSH_EVAL_CONTEXT && $ZSH_EVAL_CONTEXT =~ :file$ ]] || 
  [[ -n $KSH_VERSION && $(cd "$(dirname -- "$0")" &&
    printf '%s' "${PWD%/}/")$(basename -- "$0") != "${.sh.file}" ]] || 
  [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)) && sourced=1 || sourced=0

# If script being called directly run immediatley
if [ $sourced -eq 0 ]; then
  welcome $@
fi

# EOF
