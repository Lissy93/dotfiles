#!/usr/bin/env bash

# A quick utility for checking if you're online
# Checks interfaces, gateway, DNS, conntectivity
# Licensed under MIT, (C) Alicia Sykes 2022

# Colors and re-used string components
pre_general='\033[1;96m'
pre_success='  \033[1;92m✔'
pre_failure='  \033[1;91m✗'
post_string='\x1b[0m'

function aio_http_host () {
  wget -qO- github.com > /dev/null 2>&1 || { echo "Error: no active internet connection" >&2; return 1; }
}

# Checks if DNS gateway is online
function aio_check-dns() {
  : >/dev/tcp/1.1.1.1/53 > /dev/null && \
  echo -e "${pre_success} DNS Online${post_string}" || \
  echo -e "${pre_failure} DNS Offline${post_string}"
}

# Checks if can ping default getway
function aio_ping-gateway() { 
  ping -q -c 1 `ip r | grep default | cut -d ' ' -f 3 | head -1` > /dev/null && \
  echo -e "${pre_success} Gateway Availible${post_string}" || \
  echo -e "${pre_failure} Gateway Unavailible${post_string}"
}

# Checks if can curl a URL
function aio_check-url() {
  INTERNET_URL="${INTERNET_URL:-$1}"
    if [ -z "$(curl -Is $INTERNET_URL | head -n 1 2>&1 )" ]
    then
        echo -e "${pre_failure} Domains Unaccessible${post_string}"
    else
        echo -e "${pre_success} Domains Accessible${post_string}"
    fi
}

# Checks there are network interfaces
function aio_check-interfaces() {
  if [[ -d /sys/class/net/ ]]; then
    for interface in $(ls /sys/class/net/ | grep -v lo); do
      if [[ $(cat /sys/class/net/$interface/carrier) = 1 ]]; then OnLine=1; fi
    done
  fi
  if ! [ $OnLine ]; then
    echo -e "${pre_failure} Interfaces not Configured${post_string}"
  else
    echo -e "${pre_success} Interfaces Configured${post_string}" > /dev/stderr
  fi
}

# Shows help menu
function aio_help() {
  echo -e "${pre_general}Utility for checking connectivity status${post_string}"
  echo -e "\e[0;96mUsage:${post_string}"
  echo -e "  \e[0;96m$ online${post_string}"
}

# Runs everything, prints output
function aio_start() {
  if [[ $@ == *"--help"* ]]; then
    aio_help
    return
  fi;
  line="${pre_general}─────────────────────────${post_string}"
  echo -e ${line}
  echo -e "${pre_general}📶 Checking connection...${post_string}"
  echo -e ${line}
  aio_check-dns
  aio_ping-gateway
  aio_check-url 'https://duck.com'
  aio_check-interfaces
  echo -e ${line}
}

# Determine if file is being run directly or sourced
([[ -n $ZSH_EVAL_CONTEXT && $ZSH_EVAL_CONTEXT =~ :file$ ]] || 
  [[ -n $KSH_VERSION && $(cd "$(dirname -- "$0")" &&
    printf '%s' "${PWD%/}/")$(basename -- "$0") != "${.sh.file}" ]] || 
  [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)) && sourced=1 || sourced=0

# If script being called directly run immediatley, otherwise register aliases
if [ $sourced -eq 0 ]; then
  aio_start $@
else
  alias amionline=aio_start $@
  alias online=aio_start $@
  alias aio=aio_start $@
fi
