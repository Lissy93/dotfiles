#!/usr/bin/env zsh


# Configure completion cache.
zstyle ':completion::complete:*'    use-cache           yes                             # Enable cache for completions.
zstyle ':completion::complete:*'    cache-path          "${ZDOTDIR:-$HOME}/.zcompcache" # Configure completion cache path.

# Configure matches and grouping in completion menu.
zstyle ':completion:*'              matcher-list        'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*' # Enable case insensitive completion.
zstyle ':completion:*:*:*:*:*'      menu                select                                      # Enable highlighting in menu.
zstyle ':completion:*:options'      auto-description    '%d'
zstyle ':completion:*:options'      description         yes
zstyle ':completion:*:matches'      group               yes                                         # Separate matches in menu into groups.
zstyle ':completion:*'              group-name          ''                                          # Separate matches in menu into groups.

# Format group matches in completion menu.
#zstyle ':completion:*:descriptions' format              '%F{yellow}-- %d --%f'             # Comment when using fzf-tab plugin. For more information,
zstyle ':completion:*:descriptions' format              '[%d]'                              # see https://github.com/Aloxaf/fzf-tab/issues/43.
zstyle ':completion:*:corrections'  format              '%F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:messages'     format              '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings'     format              '%F{red}-- no matches found --%f'

# Configure completion of directories.
zstyle ':completion:*'              list-colors         ${(s.:.)LS_COLORS}  # Enable $LS_COLORS for directories in completion menu.
zstyle ':completion:*'              special-dirs        yes                 # Enable completion menu of ./ and ../ special directories.

# Configure completion of 'kill' command.
zstyle ':completion:*:*:*:*:processes'      command             'ps -u $USER -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes'   list-colors         '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:kill:*'             menu                yes select
zstyle ':completion:*:*:kill:*'             force-list          always
zstyle ':completion:*:*:kill:*'             insert-ids          single

# Configure completion of 'man' command.
zstyle ':completion:*:man:*'                menu                yes select
zstyle ':completion:*:manuals'              separate-sections   yes
zstyle ':completion:*:manuals.*'            insert-sections     yes

################################################################################
#  INITIALIZE & OPTIMIZE COMPLETION SYSTEM
################################################################################
#
# Performance tweaking of compinit based on information from the following
# sources.
#   - https://carlosbecker.com/posts/speeding-up-zsh
#   - https://gist.github.com/ctechols/ca1035271ad134841284
#
# On slow systems, checking the cached .zcompdump file to see if it must be
# regenerated adds a noticable delay to Zsh startup. The solution below
# restricts it to once a day.
#
# See below for infromation on the globbing used.
#   '#q' : Explicit glob qualifier that makes globbing work within Zsh's [[ ]]
#          construct.
#   'N'  : Makes the glob pattern evaluate to nothing when it does not match,
#          rather than throwing a globbing error.
#   '.'  : Match "regular files".
#   'm1' : Match files (or directories or whatever) that are older than 1 day.

# Autoload completion functions.
#   -U : Mark the fucntion for autoloading and suppress alias expansion.
#   -z : Use Zsh instead of Korn shell style functions.
autoload -Uz compinit

# Enable extended globbing.
setopt extendedglob

# Perform compinit only once a day.
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m1) ]]; then
    compinit
    echo "Initializing completions..."
else
    # Skip compinit security check entirely.
    compinit -c
fi

# Disable extended globbing so that ^ will behave as normal.
unsetopt extendedglob