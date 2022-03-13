
command_exists () {
  hash "$1" 2> /dev/null
}

# Use exa package (if installed) for better ls
# if command_exists exa ; then
#     alias ls='exa'
#     alias la='exa -a --icons'
#     alias tree='f() { exa -a --tree -L=${1:-2} --icons };f'
#     alias recent='exa -lahr --color-scale --icons --git --git-ignore -s=modified'
# else
#     alias la='ls -a'
# fi

# Shorter ls
alias l='ls' # List files, will use exa if availible
alias ll='ls -laFh' # List all files, with details, type indicators and headings


alias dud='du -d 1 -h' # List sizes of files within directory
alias duf='du -sh *' # List total size of current directory
alias ff='find . -type f -name' # Find a file by name within current directory
(( $+commands[fd] )) || alias fd='find . -type d -name' # Find direcroy by name

alias hist='history'
alias histsearch='fc -El 0 | grep' # Searchses for a word in terminal history

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
