
# Directory for all-things ZSH config
zsh_dir=${${ZDOTDIR}:-$HOME/.config/zsh}

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Import ZSH settings file
source ${zsh_dir}/zsh-config.zsh

# Configure ZSH stuff
source ${zsh_dir}/lib/history.zsh
source ${zsh_dir}/lib/colors.zsh
source ${zsh_dir}/lib/completion.zsh
source ${zsh_dir}/lib/term-title.zsh

# Import alias files
source ${zsh_dir}/aliases/git.zsh
source ${zsh_dir}/aliases/general.zsh

# Setup Antigen bundle manager
source ${zsh_dir}/helpers/setup-antigen.zsh

# Then import Antigen plugins
source ${zsh_dir}/helpers/import-plugins.zsh

# Import P10k config for command prompt, run `p10k configure` or edit
[[ ! -f ${zsh_dir}/.p10k.zsh ]] || source ${zsh_dir}/.p10k.zsh
