
command_exists () {
  hash "$1" 2> /dev/null
}

alias_not_used () {
  ! alias "$1" >/dev/null && ! hash "$1" 2> /dev/null
}

# Single-letter aliases, for frequently used basics, only if not already set
if alias_not_used a; then; alias a='alias'; fi
if alias_not_used c; then; alias c='clear'; fi
if alias_not_used d; then; alias c='date'; fi
if alias_not_used e; then; alias e='exit'; fi
if alias_not_used f; then; alias f='find'; fi
if alias_not_used g; then; alias g='grep'; fi
if alias_not_used h; then; alias h='history'; fi
if alias_not_used i; then; alias i='id'; fi
if alias_not_used j; then; alias j='jobs'; fi
if alias_not_used l; then; alias l='ls'; fi
if alias_not_used m; then; alias m='man'; fi
if alias_not_used p; then; alias p='pwd'; fi
if alias_not_used s; then; alias s='sudo'; fi
if alias_not_used t; then; alias t='touch'; fi
if alias_not_used v; then; alias v='vim'; fi

# File listing options
alias lr='ls -R' # List files in sub-directories, recursivley
alias lf='ls -A | grep' # Use grep to find files
alias lc='find . -type f | wc -l' # Shows number of files
alias ld='ls -l | grep "^d"' # List directories only

# If exa installed, then use exa for some ls commands
if command_exists exa ; then
  alias l='exa -aF --icons' # Quick ls
  alias la='exa -aF --icons' # List all
  alias ll='exa -laF --icons' # Show details
  alias lm='exa -lahr --color-scale --icons -s=modified' # Recent
  alias lb='exa -lahr --color-scale --icons -s=size' # Largest / size
  alias tree='f() { exa -aF --tree -L=${1:-2} --icons };f'
else
  alias la='ls -A' # List all files/ includes hidden
  alias ll='ls -lAFh' # List all files, with full details
  alias lb='ls -lhSA' # List all files sorted by biggest
  alias lm='ls -tA -1' # List files sorted by last modified
fi

# List contents of packed file, depending on type
ls-archive () {
  if [ -z "$1" ]; then
    echo "No archive specified"
    return;
  fi
  if [[ ! -f $1 ]]; then
    echo "File not found"
    return;
  fi
  ext="${1##*.}"
  if [ $ext = 'zip' ]; then
    unzip -l $1
  elif [ $ext = 'rar' ]; then
    unrar l $1
  elif [ $ext = 'tar' ]; then
    tar tf $1
  elif [ $ext = 'tar.gz' ]; then
    echo $1
  elif [ $ext = 'ace' ]; then
    unace l $1
  else
    echo "Unknown Archive Format"
  fi
}

alias lz='ls-archive'

# Make directory, and cd into it
mkcd() {
  local dir="$*";
  mkdir -p "$dir" && cd "$dir";
}

# Make dir and copy
mkcp() {
  local dir="$2"
  local tmp="$2"; tmp="${tmp: -1}"
  [ "$tmp" != "/" ] && dir="$(dirname "$2")"
  [ -d "$dir" ] ||
    mkdir -p "$dir" &&
    cp -r "$@"
}

# Move dir and move into it
mkmv() {
  local dir="$2"
  local tmp="$2"; tmp="${tmp: -1}"
  [ "$tmp" != "/" ] && dir="$(dirname "$2")"
  [ -d "$dir" ] ||
      mkdir -p "$dir" &&
      mv "$@"
}

# Getting outa directories
alias c~='cd ~'
alias c.='cd ..'
alias c..='cd ../../'
alias c...='cd ../../../'
alias c....='cd ../../../../'
alias c.....='cd ../../../../'
alias cg='cd `git rev-parse --show-toplevel`' # Base of git project

# Finding files and directories
alias dud='du -d 1 -h' # List sizes of files within directory
alias duf='du -sh *' # List total size of current directory
alias ff='find . -type f -name' # Find a file by name within current directory
(( $+commands[fd] )) || alias fd='find . -type d -name' # Find direcroy by name

# Command line history
alias h='history' # Shows full history
alias h-search='fc -El 0 | grep' # Searchses for a word in terminal history
alias top-history='history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head' 
alias histrg='history -500 | rg' # Rip grep search recent history

# Clearing terminal
if command_exists hr ; then
  alias c='clear && hr_color='\033[0;37m' && hr'
else
  alias c='clear'
fi

# Command line head / tail shortcuts
alias -g H='| head' # Pipes output to head (the first part of a file)
alias -g T='| tail' # Pipes output to tail (the last part of a file)
alias -g G='| grep' # Pipes output to grep to search for some word
alias -g L="| less" # Pipes output to less, useful for paging
alias -g M="| most" # Pipes output to more, useful for paging
alias -g LL="2>&1 | less" # Writes stderr to stdout and passes it to less
alias -g CA="2>&1 | cat -A" # Writes stderr to stdout and passes it to cat
alias -g NE="2> /dev/null" # Silences stderr
alias -g NUL="> /dev/null 2>&1" # Silences both stdout and stderr
alias -g P="2>&1| pygmentize -l pytb" # Writes stderr to stdout, and passes to pygmentize

# Use color diff, if availible
if command_exists colordiff ; then
  alias diff='colordiff'
fi

# Find + manage aliases
alias al='alias | less' # List all aliases
alias as='alias | grep' # Search aliases
alias ar='unalias' # Remove given alias

# System Monitoring
alias meminfo='free -m -l -t' # Show free and used memory
alias memhog='ps -eo pid,ppid,cmd,%mem --sort=-%mem | head' # Processes consuming most mem
alias cpuhog='ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head' # Processes consuming most cpu
alias cpuinfo='lscpu' # Show CPU Info
alias distro='cat /etc/*-release' # Show OS info
alias ports='netstat -tulanp' # Show open ports

# Copy / pasting
alias cpwd='pwd | pbcopy' # Copy current path
alias pa='pbpaste' # Paste clipboard contents

# App Specific
if command_exists code ; then; alias vsc='code .'; fi # Launch VS Code in current dir
if command_exists cointop ; then; alias crypto='cointop'; fi
if command_exists gotop ; then; alias gto='gotop'; fi

# External Services
alias myip='curl icanhazip.com'
alias weather='curl wttr.in'
alias weather-short='curl "wttr.in?format=3"'
alias cheat='curl cheat.sh/'
alias tinyurl='curl -s "http://tinyurl.com/api-create.php?url='
alias joke='curl https://icanhazdadjoke.com'
alias hackernews='curl hkkr.in'
alias worldinternet='curl https://status.plaintext.sh/t'

# Random lolz
alias cls='clear;ls' # Clear and ls
alias plz="fc -l -1 | cut -d' ' -f2- | xargs sudo" # Re-run last cmd as root
alias yolo='git add .; git commit -m "YOLO"; git push origin master'
alias when='date' # Show date
alias whereami='pwd'
alias dog='cat'
alias gtfo='exit'

# Alias for install script
alias dotfiles="${DOTFILES_DIR:-$HOME/Documents/config/dotfiles}/install.sh"
alias dots="dotfiles"
