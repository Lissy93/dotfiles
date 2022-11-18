# Mimic Tim Pope’s Vim surround plugin
# When in normal mode, use:
# - cs (change surrounding)
# - ds (delete surrounding)
# - ys (add surrounding)

autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround