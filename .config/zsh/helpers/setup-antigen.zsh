

zsh_dir=${XDG_CONFIG_HOME:-$HOME/.config}/zsh
antigen_dir=${ADOTDIR:-$XDG_DATA_HOME/zsh/antigen}

typeset -a ANTIGEN_CHECK_FILES=(${zsh_dir}/.zshrc ${antigen_dir}/antigen.zsh)

export ANTIGEN_AUTO_CONFIG=false

# Import angigen if present, or prompt to install if missing
if [[ -f $antigen_dir/antigen.zsh ]]; then
  source $antigen_dir/antigen.zsh
else
  if read -q "choice?Would you like to install Antigen now? (y/N)"; then
    echo
    mkdir -p $antigen_dir
    curl -L git.io/antigen > $antigen_dir/antigen.zsh
    source $antigen_dir/antigen.zsh
  fi
fi

# Create (if needed), then set path to antigen cache directory
# antigen_cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/antigen
# if [ ! -d $antigen_cache_dir ]; then
#   mkdir -p $antigen_cache_dir
# fi
# export ANTIGEN_CACHE=$antigen_cache_dir
