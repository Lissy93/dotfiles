
# Directory for all-things ZSH config
zsh_dir=${${ZDOTDIR}:-$HOME/.config/zsh}

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Import alias files
source ${zsh_dir}/aliases/git.zsh

# Setup Antigen bundle manager
source ${zsh_dir}/helpers/setup-antigen.zsh

# Then import Antigen plugins
source ${zsh_dir}/helpers/import-plugins.zsh

# Enable auto-completion
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

# Import P10k config for command prompt, run `p10k configure` or edit
[[ ! -f ${zsh_dir}/.p10k.zsh ]] || source ${zsh_dir}/.p10k.zsh
