#!/usr/bin/env bash

######################################################################
# Quick Web Server                                                   #
######################################################################
# Locally serves up current (or specified) directory on given port   #
# For docs and more info, see: https://github.com/lissy93/dotfiles   #
#                                                                    #
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
######################################################################

PARAMS=$*

# Start web server with Python
function qs_python () {
  echo "Starting sercer - Python"
  # python -m http.server 8000
}

# Start web server with Node.js
function qs_node () {
  echo "Starting sercer - Node"
  # npx http-server ./ --port 8080
}

# Start web server with PHP
function qs_php () {
  echo "Starting sercer - PHP"
  # php -S 127.0.0.1:8080
}

# Start web server with Ruby
function qs_ruby () {
  echo "Starting sercer - Ruby"
  # ruby -run -e httpd ./ -p 8080
}

# Start web server with R
function qs_r () {
  echo "Starting sercer - R"
  # Rscript -e 'servr::httd()' -p8080
}

# Start web server with Caddy
function qs_caddy () {
  echo "Starting sercer - Caddy"
  # caddy file-server
}

# Start web server with Rust (using miniserve)
function qs_rust () {
  echo "Starting sercer - Rust"
  cargo install miniserve
  # miniserve -p 8080 .
}

# Start web server with BusyBox
function qs_busybox () {
  echo "Starting sercer - BusyBox"
  # busybox httpd -f -p 8080
}

function qs_print_usage () {
  echo -e "TODO: Print help menu"
}

# Start web server without prompting user for options
quick_start_server () {
  echo "Start"
}

# Planning
# Needs: server type, port, directory



select_web_server() {
  # If help flag specified, show help
  [[ $PARAMS == *"--help"* || $PARAMS == "help" ]] && qs_print_usage && return

  # Define options for Lang, Port and Dir
  QS_LANG=''
  QS_PORT=''
  QS_DIR=''

  # Get port from parameters, or default to next availible one

  # Get directory to serve up from parameters, or default to current one

  # If user specified web server, jump strait to that function
  if [ -n "$PARAMS" ]; then
    [[ $PARAMS == "python"* ]] && qs_python $port $dir && return
    [[ $PARAMS == "node"* ]] && qs_node $port $dir && return
    [[ $PARAMS == "php"* ]] && qs_php $port $dir && return
    [[ $PARAMS == "ruby"* ]] && qs_ruby $port $dir && return
    [[ $PARAMS == "rlang"* ]] && qs_r $port $dir && return
    [[ $PARAMS == "caddy"* ]] && qs_caddy $port $dir && return
    [[ $PARAMS == "rust"* ]] && qs_rust $port $dir && return
    [[ $PARAMS == "busybox"* ]] && qs_busybox $port $dir && return
  fi
  # Otherwise show menu input for search engines
  choices=( python node php ruby rlang caddy rust busybox 'help' quit )
  PS3='❯ '
  echo -e "\033[1;95mSelect a Server Option\033[0;35m"
  select opt in ${choices[@]}; do
    case $opt in
      python) qs_python $@; return;;
      node) qs_node $@; return;;
      php) qs_php $@; return;;
      ruby) qs_ruby $@; return;;
      rlang) qs_r $@; return;;
      caddy) qs_caddy $@; return;;
      rust) qs_rust $@; return;;
      busybox) qs_busybox $@; return;;
      help) qs_print_usage;;
      quit) break ;;
      *)
        echo -e "\033[0;93mInvalid option: '$REPLY'\e[0m"
        echo -e "\033[0;33mEnter the number corresponding to one of the above options\e[0m"
      ;;
    esac
  done
}

select_web_server
