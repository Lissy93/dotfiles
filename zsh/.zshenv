#  ~/.zshenv
# Core envionmental variables

# Set XDG directories
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_BIN_HOME="${HOME}/.local/bin"
export XDG_LIB_HOME="${HOME}/.local/lib"
export XDG_CACHE_HOME="${HOME}/.cache"

# Set default applications
export EDITOR="vim"
export TERMINAL="konsole"
export BROWSER="firefox"
export PAGER="less"

## Respect XDG directories
export ADOTDIR="${XDG_CACHE_HOME}/zsh/antigen"
export OPENSSL_DIR="/usr/local/ssl"
export ANTIBODY_HOME=${XDG_DATA_HOME}/antibody
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export GIT_CONFIG="${XDG_CONFIG_HOME}/git/.gitconfig"
export KDEHOME="${XDG_CONFIG_HOME}/kde"
export LESSHISTFILE="-" # Disable less history.
export PASSWORD_STORE_DIR="${XDG_DATA_HOME}/pass"
export PIP_CONFIG_FILE="${XDG_CONFIG_HOME}/pip/pip.conf"
export PIP_LOG_FILE="${XDG_DATA_HOME}/pip/log"
export VIMINIT=":source $XDG_CONFIG_HOME/vim/vimrc"
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"
export XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"
export XSERVERRC="${XDG_CONFIG_HOME}/X11/xserverrc"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export ZLIB="${ZDOTDIR}/lib"

# source $XDG_CONFIG_HOME/zsh/.zshrc

# Add Brew to path, if installed and on MacOS
if [ "$(uname -s)" = "Darwin" ] && [[ -d /opt/homebrew/bin ]]; then
    export PATH=/opt/homebrew/bin:$PATH
fi
