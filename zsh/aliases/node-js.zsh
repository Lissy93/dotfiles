
# Aliases and helper functions for Node.js projects, including yarn, npm, nvm

# Yarn - Project commands
alias ys='yarn start'
alias yt='yarn test'
alias yb='yarn build'
alias yl='yarn lint'
alias yd='yarn dev'
alias yp='yarn publish'
alias yr='yarn run'

# Yarn - Package management
alias ya='yarn add'
alias ye='yarn remove'
alias yi='yarn install'
alias yg='yarn upgrade'
alias yu='yarn update'
alias yf='yarn info'

# Yarn - Misc
alias yz='yarn audit'
alias yc='yarn autoclean'
alias yk='yarn check'
alias yh='yarn help'

# Nuke - Remove node_modules and the lock file, then reinstall
reinstall_modules () {
  if read -q "choice?Remove and reinstall all node_modules? (y/N)"; then
    echo
    project_dir=$(pwd)
    if [ -d "$project_dir/node_modules" ]; then
      echo -e "\e[35mRemoveing node_modules...\e[0m"
      rm -rf "$project_dir/node_modules"
    fi
    if [ -f "$project_dir/yarn.lock" ]; then
      echo -e "\e[35mRemoveing yarn.lock...\e[0m"
      rm "$project_dir/yarn.lock"
    fi
    if [ -f "$project_dir/package-lock.json" ]; then
      echo -e "\e[35mRemoveing package-lock.json..."
      rm "$project_dir/package-lock.json"
    fi
    if hash 'yarn' 2> /dev/null; then
      echo -e "\e[35mReinstalling with yarn...\e[0m"
      yarn
      echo -e "\e[35mCleaning Up...\e[0m"
      yarn autoclean
    else
      echo -e "\e[35mReinstalling with NPM...\e[0m"
      npm install
    fi
  else
    echo -e "\n\e[35mAborting...\e[0m"
  fi
}

alias yn='reinstall_modules'

# Prints out versions of core Node.js packages
print_node_versions () {
  nreset='\033[0m'
  versions=''
  get_version () {
    if hash $1 2> /dev/null; then
      versions="$versions\e[36m\e[1m $2: \033[0m\033[3m$($1 --version)\n"
    else
      versions="$versions\e[33m\e[1m $2: \033[0m\033[3m Not installed\n"
    fi
  }
  get_version 'node' 'Node.js'
  get_version 'npm' 'NPM'
  get_version 'yarn' 'Yarn'
  get_version 'nvm' 'NVM'
  echo -e $versions
}

alias yv='print_node_versions'

# Legacy support for NPM
alias npmi='npm install'
alias npmu='npm uninstall'
alias npmr='npm run'
alias npms='npm start'
alias npmt='npm test'
alias npml='npm run lint'
alias npmd='npm run dev'
alias npmp='npm publish'

# Location of NVM, will inherit from .zshenv if set
NVM_DIR=${NVM_DIR:-$XDG_DATA_HOME/nvm}

# If NVM present, then import it
if [ -f "$nvm_location/nvm.sh" ]; then
  source "${NVM_DIR}/nvm.sh"
fi

# Helper function to install NVM
install_nvm () {
  nvm_repo='https://github.com/nvm-sh/nvm.git'
  if [ -d "$NVM_DIR" ]; then # Already installed, update
    cd $NVM_DIR && git pull
  else # Not yet installed, promt user to confirm before proceeding
    if read -q "choice?Install NVM now? (y/N)"; then
      echo -e "\nInstalling..."
      git clone $nvm_repo $NVM_DIR
      cd $NVM_DIR && git checkout v0.39.1
    else
      echo -e "\nAborting..."
      return
    fi
  fi
  # All done, import / re-import NVM script
  source "${NVM_DIR}/nvm.sh"
}

# NVM commands
alias nvmi='nvm install'
alias nvmu='nvm use'
alias nvml='nvm ls'
alias nvmr='nvm run'
alias nvme='nvm exec'
alias nvmw='nvm which'
alias nvmlr='nvm ls-remote'
alias nvmlts='nvm install --lts && nvm use --lts'
alias nvmlatest='nvm install node --latest-npm && nvm use node'
alias nvmsetup='install_nvm'
