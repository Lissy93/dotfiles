
# Directory for all-things ZSH config
zsh_dir=${${ZDOTDIR}:-$HOME/.config/zsh}
utils_dir=~/.config/utils

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Import alias files
source ${zsh_dir}/aliases/general.zsh
source ${zsh_dir}/aliases/git.zsh
source ${zsh_dir}/aliases/node-js.zsh
source ${zsh_dir}/aliases/flutter.zsh
# source ${zsh_dir}/aliases/alias-tips.zsh

# Setup Antigen, and import plugins
source ${zsh_dir}/helpers/setup-antigen.zsh
source ${zsh_dir}/helpers/import-plugins.zsh

# Configure ZSH stuff
source ${zsh_dir}/lib/colors.zsh
source ${zsh_dir}/lib/cursor.zsh
source ${zsh_dir}/lib/history.zsh
source ${zsh_dir}/lib/surround.zsh
source ${zsh_dir}/lib/completion.zsh
source ${zsh_dir}/lib/term-title.zsh
source ${zsh_dir}/lib/navigation.zsh
source ${zsh_dir}/lib/expansions.zsh
source ${zsh_dir}/lib/key-bindings.zsh

# Import utility functions
source ${utils_dir}/transfer.sh
source ${utils_dir}/matrix.sh
source ${utils_dir}/hr.sh
source ${utils_dir}/web-search.sh
source ${utils_dir}/am-i-online.sh
source ${utils_dir}/welcome-banner.sh
source ${utils_dir}/color-map.sh

# Left over tasks
source ${zsh_dir}/helpers/misc-stuff.zsh

# Import P10k config for command prompt, run `p10k configure` or edit
[[ ! -f ${zsh_dir}/.p10k.zsh ]] || source ${zsh_dir}/.p10k.zsh

# If not running in nested shell, then show welcome message :)
if [[ "${SHLVL}" -lt 2 ]]; then
  welcome
fi
