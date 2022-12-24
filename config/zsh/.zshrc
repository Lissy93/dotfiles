######################################################################
# ~/.config/zsh/.zshrc                                               #
######################################################################
# Instructions to be executed when a new ZSH session is launched     #
# Imports all plugins, aliases, helper functions, and configurations #
#                                                                    #
# After editing, re-source .zshrc for new changes to take effect     #
# For docs and more info, see: https://github.com/lissy93/dotfiles   #
######################################################################
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
######################################################################

# Directory for all-things ZSH config
zsh_dir=${${ZDOTDIR}:-$HOME/.config/zsh}
utils_dir="${XDG_CONFIG_HOME}/utils"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source all ZSH config files (if present)
if [[ -d $zsh_dir ]]; then
  # Import alias files
  source ${zsh_dir}/aliases/general.zsh
  source ${zsh_dir}/aliases/git.zsh
  source ${zsh_dir}/aliases/node-js.zsh
  source ${zsh_dir}/aliases/flutter.zsh
  source ${zsh_dir}/aliases/alias-tips.zsh

  # Setup Antigen, and import plugins
  source ${zsh_dir}/helpers/setup-antigen.zsh
  source ${zsh_dir}/helpers/import-plugins.zsh
  source ${zsh_dir}/helpers/misc-stuff.zsh

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
fi

# Import utility functions
if [[ -d $utils_dir ]]; then
  source ${utils_dir}/transfer.sh
  source ${utils_dir}/matrix.sh
  source ${utils_dir}/hr.sh
  source ${utils_dir}/web-search.sh
  source ${utils_dir}/am-i-online.sh
  source ${utils_dir}/welcome-banner.sh
  source ${utils_dir}/color-map.sh
fi

# Import P10k config for command prompt, run `p10k configure` or edit
[[ ! -f ${zsh_dir}/.p10k.zsh ]] || source ${zsh_dir}/.p10k.zsh

# MacOS-specific services
if [ "$(uname -s)" = "Darwin" ]; then
  # Add Brew to path, if it's installed
  if [[ -d /opt/homebrew/bin ]]; then
    export PATH=/opt/homebrew/bin:$PATH
  fi

  # If using iTerm, import the shell integration if availible
  if [[ -f "${XDG_CONFIG_HOME}/zsh/.iterm2_shell_integration.zsh" ]]; then
    source "${XDG_CONFIG_HOME}/zsh/.iterm2_shell_integration.zsh"
  fi

  # Append the Android SDK locations to path
  if [[ -d "${HOME}/Library/Android/" ]]; then
    export PATH="${HOME}/Library/Android/sdk/emulator:${PATH}"
    export ANDROID_HOME="${HOME}/Library/Android/sdk"
    export ANDROID_SDK_ROOT="${HOME}/Library/Android/sdk"
    export ANDROID_AVD_HOME="${ANDROID_SDK_ROOT}/tools/emulator"
    export NODE_BINARY="/usr/local/bin/node"
  fi
fi

# Add Zoxide (for cd, quick jump) to shell
if hash zoxide 2> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# If not running in nested shell, then show welcome message :)
if [[ "${SHLVL}" -lt 2 ]] && [[ -z "$SKIP_WELCOME" ]]; then
  welcome
fi
