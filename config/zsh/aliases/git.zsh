
######################################################################
# ZSH aliases and helper functions for working with Git              #
#                                                                    #
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
######################################################################

# Basics
alias g="git"
alias gs="git status" # List changed files
alias ga="git add" # Add <files> to the next commit
alias gaa="git add ." # Add all changed files
alias grm="git rm" # Remove <file>
alias gc="git commit" # Commit staged files, needs -m ""
alias gps="git push" # Push local commits to <origin> <branch>
alias gpl="git pull" # Pull changes with <origin> <branch>
alias gf="git fetch" # Download branch changes, without modifying files

# Merging and Rebasing
alias grb="git rebase" # Rebase the current HEAD into <branch>
alias grba="git rebase --abort" # Cancel current rebase sesh
alias grbc="git rebase --continue" # Continue onto next diff
alias gm="git merge" # Merge <branch> into your current HEAD

# Repo setup
alias gi="git init" # Initiialize a new empty local repo
alias gcl="git clone" # Downloads repo from <url>

# Branching
alias gch="git checkout" # Switch the HEAD to <branch>
alias gb="git branch" # Create a new <branch> from HEAD
alias gd="git diff" # Show all changes to untracked files
alias gtree="git log --graph --oneline --decorate --abbrev-commit" # Show branch tree
alias gl='git log'

# Tags
alias gt="git tag" # Tag the current commit, 1 param
alias gtl="git tag -l" # List all tags, optionally with pattern
alias gtlm="git tag -n" # List all tags, with their messages
alias gtp="git push --tags" # Publish tags

# Origin
alias gr="git remote"
alias grs="git remote show" # Show current remote origin
alias grl="git remote -v" # List all currently configured remotes
alias grr="git remote rm origin" # Remove current origin
alias gra="git remote add" # Add new remote origin
alias grurl="git remote set-url origin" # Sets URL of existing origin

# Undoing
alias guc="git revert" # Revert a <commit>
alias gu="git reset" # Reset HEAD pointer to a <commit>, perserves changes
alias gua="git reset --hard HEAD" # Resets all uncommited changes
alias gnewmsg="git commit --amend -m" # Update <message> of previous commit
alias gclean="git clean -df" # Remove all untracked files

# Git LFS
alias glfsi='git lfs install'
alias glfst='git lfs track'
alias glfsls='git lfs ls-files'
alias glfsmi='git lfs migrate import --include='

# Push LFS changes to current branch
function gplfs() {
  git lfs push origin "$(git_current_branch)" --all
}

alias gx='cd $(git rev-parse --show-toplevel)'

# Navigate back to project root (where .git is)
function jump-to-git-root {
  local _root_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [[ $? -gt 0 ]]; then
    >&2 echo '\033[1;93m Not a Git repo\033[0m'
    exit 1
  fi
  local _pwd=$(pwd)
  if [[ $_pwd = $_root_dir ]]; then
    # Handle submodules
    _root_dir="$(git -C $(dirname $_pwd) rev-parse --show-toplevel 2>/dev/null)"
    if [[ $? -gt 0 ]]; then
      echo "\033[0;96m Already at Git repo root.\033[0m"
      return 0
    fi
  fi
  # Make `cd -` work.
  OLDPWD=$_pwd
  echo "\033[0;96m Git repo root: $_root_dir\033[0m"
  cd $_root_dir
}

alias gj='jump-to-git-root'

# Shorthand clone (e.g. $ clone lissy93/dotfiles)
function clone {
  default_service='github.com' # Used if full URL isn't specified
  default_username='lissy93' # Used if repo org / username isn't specified
  use_ssh=true # Use SSH instead of HTTPS
  user_input=$1
  target=${2:-''}
  # Help flag passed, show manual and exit  
  if [[ $user_input == --help ]] || [[ $user_input == -h ]]; then
    echo -e 'This will clone a git repo, and cd into it.';
    echo -e 'Either specify repo name, oe user/repo, or a full URL.'
    echo -e 'If no target directory is specified, the repo name will be used.'
    echo -e 'E.g. `$ clone lissy93/dotfiles`'
    return;
  # No input specified, prompt user
  elif [ $# -eq 0 ]; then
    echo 'Enter a user/repo or full URL: ';
    read user_input;
  fi
  # Determine input type, and make clone url
  if [[ $user_input == git@* || $user_input == *://* ]]
  then
    # Full URL was provided
    REPO_URL=$user_input;
  elif [[ $user_input == */* ]]; then
    # Username/repo was provided
    if [ "$use_ssh" = true ] ; then
      REPO_URL="git@$default_service:$user_input.git";
    else
      REPO_URL="https://$default_service/$user_input.git";
    fi
  else
    # Just repo name was provided
    if [ "$use_ssh" = true ] ; then
      REPO_URL="git@$default_service:$default_username/$user_input.git";
    else
      REPO_URL="https://$default_service/$default_username/$user_input.git";
    fi
  fi

  # Clone repo
  git clone $REPO_URL $target;
  
  # cd into newly cloned directory
  cd "$(basename "$_" .git)"

  # Print results
  if test "$?" -eq 0; then
    echo -e "☑️  \033[1;96mCloned $REPO_URL into $(pwd), and cd'd into it.\033[0m"
  else
    echo -e "❌ \033[1;91mFailed to clone $REPO_URL\033[0m"
  fi
}

# Sync fork against upstream repo
function gsync {
  # If no upstream origin provided, prompt user for it
  if ! git remote -v | grep -q 'upstream'; then
    echo 'Enter the upstream git url: ';
    read url;
    git remote add upstream "$url"
  fi
  git remote -v
  git fetch upstream
  git pull upstream master
  git checkout master
  git rebase upstream/master
}

# Make git commit with -m
function gcommit {
  commit_msg=$@
  if [ $# -eq 0 ]; then
    echo 'Enter a commit message';
    read commit_msg;
  fi
  git commit -m "$commit_msg"
}

alias gcm="gcommit"

# Fetch, rebase and push updates to current branch 
# Optionally specify target, defaults to 'master'
function gfetchrebase {
  if ! [ -z "$1" ]; then
    branch=$1
  else
    branch='master'
  fi
  git fetch upstream
  git rebase upstream/$branch
  git push
}

alias gfrb="gfetchrebase"

# Integrates with gitignore.io to auto-populate .gitignore file
function gignore() {
  curl -fLw '\n' https://www.gitignore.io/api/"${(j:,:)@}"
}
_gitignoreio_get_command_list() {
  curl -sfL https://www.gitignore.io/api/list | tr "," "\n"
}
_gitignoreio () {
  compset -P '*,'
  compadd -S '' `_gitignoreio_get_command_list`
}
# Downloads specific git ignore template to .gitignore
gignore-apply () {
  if [ -n $search_term ]; then
    gignore $1 >> .gitignore
  else
    echo "Expected a template to be specified. Run:"
    echo "  $ gignore list to view all options"
    echo "  $ gignore [template] to preview"
  fi
}

# Helper function to return URL of current repo (based on origin)
get-repo-url() {
  git_base_url='https://github.com'
  # Get origin from git repo + remove .git
  git_url=${$(git config --get remote.origin.url)%.git}
  # Process URL, and append branch / working origin 
  if [[ $git_url =~ ^git@ ]]; then
    branch=${1:-"$(git symbolic-ref --short HEAD)"}
    branchExists="$(git ls-remote --heads $git_url $branch | wc -l)"
    github="$(echo $git_url | sed 's/git@//')" # Remove git@ from the start
    github="$(echo $github | sed 's/\:/\//')" # Replace : with /
    if [[ $branchExists == "       1" ]]; then
        git_url="http://$github/tree/$branch"
    else
        git_url="http://$github"
    fi
  elif [[ $git_url =~ ^https?:// ]]; then
    branch=${1:-"$(git symbolic-ref --short HEAD)"}
    branchExists="$(git ls-remote --heads $git_url $branch | wc -l)"
    if [[ $branchExists == "       1" ]]; then
        git_url="$git_url/tree/$branch"
    else
        git_url="$git_url"
    fi
  fi
  # Return URL
  echo $git_url
}

# Helper function that gets supported open method for system
launch-url() {
  if hash open 2> /dev/null; then
    open_command=open
  elif hash xdg-open 2> /dev/null; then
    open_command=xdg-open
  elif hash lynx 2> /dev/null; then
    open_command=lynx
  else
    echo -e "\033[0;33mUnable to launch browser, open manually instead"
    echo -e "\033[1;96m🌐 URL: \033[0;96m\e[4m$1\e[0m"
    return;
  fi
  echo $open_command
}

# Opens the current repo + branch in GitHub
open-github() {
  git_base_url='https://github.com' # Modify this if using GH enterprise
  if [[ ! -z $1 && ! -z $2  ]]; then
    # User specified a repo
    git_url=$git_base_url/$1/$2
  elif git rev-parse --git-dir > /dev/null 2>&1; then
    # Get URL from current repo's origin
    git_url=$(get-repo-url)
  else
    # Not in repo, and nothing specified, open homepage
    git_url=$git_base_url
  fi
  # Determine which open commands supported
  open_command=$(launch-url $git_url)
  # Print messages
  echo -e "\033[1;96m🐙 Opening in browser: \033[0;96m\e[4m$git_url\e[0m"
  # And launch!
  $open_command $git_url
}

alias gho='open-github'

# Opens pull request tab for the current GH repo
open-github-pulls() {
  # Get Repo URL
  if git rev-parse --git-dir > /dev/null 2>&1; then
    git_url=$(get-repo-url)
  else
    git_url='https://github.com'
  fi
  git_url="$git_url/pulls"
  # Get open command
  open_command=$(launch-url $git_url)
  # Print message, and launch!
  echo -e "\033[1;96m🐙 Opening in browser: \033[0;96m\e[4m$git_url\e[0m"
  $open_command $git_url
}

alias ghp='open-github-pulls'

# Prompt for main SSH key passphrase, so u don't need to enter it again until session killed
alias add-key='eval "$(ssh-agent)" && ssh-add ~/.ssh/id_rsa'
