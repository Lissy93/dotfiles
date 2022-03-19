
command_exists () {
  hash "$1" 2> /dev/null
}

# File listing options
alias l='ls' # Quick ls
alias la='ls -A' # List all files/ includes hidden
alias ll='ls -lAFh' # List all files, with full details
alias lm='ls -tA -1' # List files sorted by last modified
alias lb='ls -lhSA' # List all files sorted by biggest
alias lr='ls -R' # List files in sub-directories, recursivley
alias lf='ls -A | grep' # Use grep to find files
alias ln='find . -type f | wc -l' # Shows number of files
alias ld='ls -l | grep "^d"' # List directories only

# If exa installed, then use exa for some ls commands
if command_exists exa ; then
    alias l='exa -aF --icons' # Quick ls
    alias la='exa -aF --icons' # List all
    alias ll='exa -laF --icons' # Show details
    alias lm='exa -lahr --color-scale --icons -s=modified' # Recent
    alias lb='exa -lahr --color-scale --icons -s=size' # Largest / size
    alias tree='f() { exa -aF --tree -L=${1:-2} --icons };f'
fi

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
alias meminfo='free -m -l -t'
alias psmem='ps auxf | sort -nr -k 4' # Show top memory eater
alias psmem10='ps auxf | sort -nr -k 4 | head -10' # Top 10 memory eaters
alias pscpu='ps auxf | sort -nr -k 3' # Show top CPU eater
alias pscpu10='ps auxf | sort -nr -k 3 | head -10' # Top 10 CPU eaters
alias cpuinfo='lscpu' # Show CPU Info
alias distro='cat /etc/*-release' # Show OS info

# Utilities
alias myip='curl icanhazip.com'
alias weather='curl wttr.in'
alias weather-short='curl "wttr.in?format=3"'
alias ports='netstat -tulanp'
if command_exists cointop ; then
  alias crypto='cointop'
fi

# Random
alias cls='clear;ls' # Clear and ls
alias plz="fc -l -1 | cut -d' ' -f2- | xargs sudo" # Re-run last cmd as root
alias yolo='git add .; git commit -m "YOLO"; git push origin master'
alias when='date' # Show date
alias whereami='pwd'
alias dog='cat'
alias simonsays='sudo'
alias gtfo='exit'