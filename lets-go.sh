######################################################################
# Lissy93/dotfiles - Remote Runnable Dotfile Setup and Update Script #
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
#                                                                    #
# This script will clone + install, or update dotfiles from git      #
# Be sure to read through the repo before running anything here      #
# For more info, read docs: https://github.com/Lissy93/dotfiles      #
#                                                                    #
# Config Options:                                                    #
# - DOTFILES_REPO - Optionally sets the source repo to be cloned     #
# - DOTFILES_DIR - Optionally sets the local destination directory   #
######################################################################

# If not already set, specify dotfiles destination directory and source repo
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Documents/config/dotfiles}"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/lissy93/dotfiles.git}"

# Print starting message
echo -e "\033[1;35m""Lissy93/Dotfiles Installation Script 🧰
\033[0;35mThis script will install or update dotfiles from \033[4;35m\
${DOTFILES_REPO}\033[0;35m into \033[4;35m${DOTFILES_DIR}\033[0;35m\n\
Be sure that you have read and understood config which will be applied.
If you don't want to proceed, press Ctrl+C to cancel now...\033[0m\n"

# If dotfiles not yet present then clone
if [[ ! -d "$DOTFILES_DIR" ]]; then
  mkdir -p "${DOTFILES_DIR}" && \
  git clone --recursive ${DOTFILES_REPO} ${DOTFILES_DIR}
fi

# Execute setup or update script
cd "${DOTFILES_DIR}" && \
chmod +x ./install.sh && \
./install.sh

# EOF
