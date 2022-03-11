# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

zsh_dir=${XDG_CONFIG_HOME:-$HOME/.config}/zsh

# Setup Antigen bundle manager
source ${zsh_dir}/helpers/setup-antigen.zsh

# Import ZSH plugins
if type "antigen" > /dev/null; then
  source ${zsh_dir}/helpers/import-plugins.zsh
else
  echo "Antigen not installed"
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
