

# Set options for pushing recent directories to stack
setopt AUTO_PUSHD # Push current dir
setopt PUSHD_IGNORE_DUPS # No duplicates
setopt PUSHD_SILENT # Don't print after pushd or popd

# Show list of recent directories
alias d='dirs -v'

# Jump to a previous directory, by index
for index ({1..9}) alias "d$index"="cd +${index}"; unset index


# Easy directory navigation
# setopt  autocd autopushd \ pushdignoredups
