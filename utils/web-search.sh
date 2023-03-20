
#!/bin/bash

##############################################
# Bash functions for launching a web search  #
#                                            #
# Usage:                                     #
# -Either source this file, or run directly  #
# -Run with --help for full list of options  #
#                                            #
# Licensed under MIT, (C) Alicia Sykes 2022  #
##############################################

# URL encodes the users search string
ws_url_encode() {
  local length="${#1}"
  for i in $(seq 0 $((length-1))); do
    local c="${1:$i:1}"
    case $c in
      [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
      *) printf '%%%02X' "'$c" ;;
    esac
  done
}

# Determines which opening method/ browser to use, and opens URL
ws_launch_url() {
  command_exists () {
    hash "$1" 2> /dev/null
  }
  if [[ $OSTYPE == 'darwin'* ]]; then
    open $1
  elif command_exists xdg-open; then
    xdg-open $1
    echo -e "\033[0;32m🌐 Launching \033[4;32m$1\033[0;90m\nPress [Enter] to exit\e[0m"
  elif command_exists lynx; then
    lynx -vikeys -accept_all_cookies $1
  elif command_exists browsh; then
    browsh $1
  elif command_exists links2; then
    links2 -g $1
  elif command_exists links; then
    links $1
  else
    echo -e "\033[0;33mUnable to launch browser, open manually instead"
    echo -e "\033[1;96m🌐 URL: \033[0;96m\e[4m$1\e[0m"
    return;
  fi
}

# Combines URL with encoded search term. Prompts user if search term missing
ws_make_search() {
  search_term=${@:2}
  if [ -z $1 ]; then # Check first parameter is present
    echo -e "\033[0;93mError, no search engine URL provided\e[0m"
    web_search
    return
  fi
  if [ -z $2 ]; then # Check second parameter, prompt user if missing
    echo "Enter Search Term: "
    read search_term
  fi
  # Encode search term, append to URL, and call launch function
  search_term=$(ws_url_encode $search_term)
  web_address="$1$search_term"
  ws_launch_url $web_address
}

# Functions that call make search, with search engines URL
ws_duckduckgo() {
  ws_make_search 'https://duckduckgo.com/?q=' $@
}
ws_wikipedia() {
  ws_make_search 'https://en.wikipedia.org/w/index.php?search=' $@
}
ws_google() {
  ws_make_search 'https://www.google.com/search?q=' $@
}
ws_github() {
  ws_make_search 'https://github.com/search?q=' $@
}
ws_stackoverflow() {
  ws_make_search 'https://stackoverflow.com/search?q=' $@
}
ws_wolframalpha() {
  ws_make_search 'https://www.wolframalpha.com/input?i=' $@
}
ws_reddit() {
  ws_make_search 'https://www.reddit.com/search/?q=' $@
}
ws_maps() {
  ws_make_search 'https://www.google.com/maps/search/' $@
}
ws_grepapp() {
  ws_make_search 'https://grep.app/search?q=' $@
}

# Lists available search options
web_search() {
  # If help flag specified, show help
  [[ $@ == *"--help"* || $@ == "help" ]] && show_ws_help && return
  # If user specified search engine, jump strait to that function
  if [ -n "${1+set}" ]; then
    [[ $@ == "duckduckgo"* ]] && ws_duckduckgo "${@/duckduckgo/}" && return
    [[ $@ == "wikipedia"* ]] && ws_wikipedia "${@/wikipedia/}" && return
    [[ $@ == "github"* ]] && ws_github "${@/github/}" && return
    [[ $@ == "stackoverflow"* ]] && ws_stackoverflow "${@/stackoverflow/}" && return
    [[ $@ == "wolframalpha"* ]] && ws_wolframalpha "${@/wolframalpha/}" && return
    [[ $@ == "reddit"* ]] && ws_reddit "${@/reddit/}" && return
    [[ $@ == "maps"* ]] && ws_maps "${@/maps/}" && return
    [[ $@ == "google"* ]] && ws_google "${@/google/}" && return
    [[ $@ == "grepapp"* ]] && ws_grepapp "${@/grepapp/}" && return
  fi
  # Otherwise show menu input for search engines
  choices=(
    duckduckgo wikipedia google github stackoverflow
    wolframalpha reddit maps grepapp 'help' quit
    )
  PS3='❯ '
  echo -e "\033[1;95mSelect a Search Option\033[0;35m"
  select opt in ${choices[@]}; do
    case $opt in
      duckduckgo) ws_duckduckgo $@; return;;
      wikipedia) ws_wikipedia $@; return;;
      google) ws_google $@; return;;
      github) ws_github $@; return;;
      stackoverflow) ws_stackoverflow $@; return;;
      wolframalpha) ws_wolframalpha $@; return;;
      reddit) ws_reddit $@; return;;
      maps) ws_maps $@; return;;
      grepapp) ws_grepapp $@; return;;
      help) show_ws_help; break;;
      quit) echo -e "\033[0;93mBye 👋\e[0m"; break ;;
      *)
        echo -e "\033[0;93mInvalid option: '$REPLY'\e[0m"
        echo -e "\033[0;33mEnter the number corresponding to one of the above options\e[0m"
        break
      ;;
    esac
  done
}

# Set up some shorthand aliases
alias web-search='web_search'
alias wsddg='ws_duckduckgo'
alias wswiki='ws_wikipedia'
alias wsgh='ws_github'
alias wsso='ws_stackoverflow'
alias wswa='ws_wolframalpha'
alias wsrdt='ws_reddit'
alias wsmap='ws_maps'
alias wsggl='ws_google'
alias wsgra='ws_grepapp'

# Set ws alias, only if not used by another program
if ! hash ws 2> /dev/null; then
  alias ws='web_search'
fi

# Prints usage options
show_ws_help() {
  echo -e '\033[1;95mCLI Web Search\e[0m'
  echo -e '\033[0;95m\x1b[2mA set of functions for searching the web from the command line.\e[0m'
  echo
  echo -e '\033[0;95m\e[4mExample Usage:\033[0;35m'
  echo -e '  (1) View menu, select search engine by index, then enter a search term'
  echo -e '    $ web-search'
  echo -e '  (2) Enter a search term, and be prompted for which search engine to use'
  echo -e '    $ web-search Hello World!'
  echo -e '  (3) Enter a search engine followed by search term'
  echo -e '    $ web-search wikipedia Matrix Defense'
  echo -e '  (4) Enter a search engine, and be prompted for the search term'
  echo -e '    $ web-search duckduckgo'
  echo
  echo -e '\033[0;95m\e[4mShorthand\033[0;35m'
  echo -e '  You can also use the `ws` alias instead of typing `web-search`'
  echo
  echo -e '\033[0;95m\e[4mSupported Search Engines:\033[0;35m'
  echo -e '  \033[0;35mDuckDuckGo: \x1b[2m$ ws duckduckgo (or $ wsddg)\e[0m'
  echo -e '  \033[0;35mWikipedia: \x1b[2m$ ws wikipedia or ($ wswiki)\e[0m'
  echo -e '  \033[0;35mGitHub: \x1b[2m$ ws github or ($ wsgh)\e[0m'
  echo -e '  \033[0;35mStackOverflow: \x1b[2m$ ws stackoverflow or ($ wsso)\e[0m'
  echo -e '  \033[0;35mWolframalpha: \x1b[2m$ ws wolframalpha or ($ wswa)\e[0m'
  echo -e '  \033[0;35mReddit: \x1b[2m$ ws reddit or ($ wsrdt)\e[0m'
  echo -e '  \033[0;35mMaps: \x1b[2m$ ws maps or ($ wsmap)\e[0m'
  echo -e '  \033[0;35mGoogle: \x1b[2m$ ws google or ($ wsggl)\e[0m'
  echo -e '  \033[0;35mGrep.App: \x1b[2m$ ws grepapp or ($ wsgra)\e[0m'
  echo -e '\e[0m'
}

# Determine if file is being run directly or sourced
([[ -n $ZSH_EVAL_CONTEXT && $ZSH_EVAL_CONTEXT =~ :file$ ]] || 
  [[ -n $KSH_VERSION && $(cd "$(dirname -- "$0")" &&
    printf '%s' "${PWD%/}/")$(basename -- "$0") != "${.sh.file}" ]] || 
  [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)) && sourced=1 || sourced=0

# If running directly, then show menu, or help
if [ $sourced -eq 0 ]; then
  if [[ $@ == *"--help"* ]]; then
    show_ws_help
  else
    web_search "$@"
  fi
fi
