
# Expands all glob expressions, subcommands and aliases (including global)
# Inspired by: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/globalias

globalias() {
  # Get last word to the left of the cursor, and split into array
  local word=${${(Az)LBUFFER}[-1]}
  # If matching alias found, then expand
  if [[ $GLOBALIAS_FILTER_VALUES[(Ie)$word] -eq 0 ]]; then
    zle _expand_alias
    zle expand-word
  fi
  zle self-insert
}

# Make function availible
zle -N globalias

# space expands all aliases, including global
bindkey -M emacs " " globalias
bindkey -M viins " " globalias

# control-space to make a normal space
bindkey -M emacs "^ " magic-space
bindkey -M viins "^ " magic-space

# normal space during searches
bindkey -M isearch " " magic-space
