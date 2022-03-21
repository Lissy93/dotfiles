# List of ZSH aliases for common git commands
# Licensed under MIT - (C) Alicia Sykes, 2022 <https://aliciasykes.com>

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
alias gtree="git log --graph --oneline --decorate" # Show branch tree

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

# Shorthand clone (e.g. $ clone lissy93/dotfiles)
function clone {
  default_service='github.com' # Used if full URL isn't specified
  default_username='lissy93' # Used if repo org / username isn't specified
  user_input=$1
  target=${2:-''}
  # Help flag passed, show manual and exit  
  if [[ $user_input == --help ]] || [[ $user_input == -h ]]; then
    echo -e 'This will clone a git repo';
    echo -e 'Either specify repo name, user/repo, or a full URL'
    echo -e 'E.g. `$ clone lissy93/dotfiles`'
    return;
  # No input specified, prompt user
  elif [ $# -eq 0 ]; then
    echo 'Enter a user/repo or full URL: ';
    read user_input;
  fi
  echo "$target"
  # Determine input type, and make clone url
  if [[ $user_input == git@* || $user_input == *://* ]]
  then
    # Full URL was provided
    REPO_URL=$user_input;
  elif [[ $user_input == */* ]]; then
    # Username/repo was provided
    REPO_URL="https://$default_service/$user_input.git";
  else
    # Just repo name was provided
    REPO_URL="https://$default_service/$default_username/$user_input.git";
  fi

  # Clone repo
  git clone $REPO_URL $target;
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

# Opens the current repo + branch in GitHub
open-github() {
  git_base_url='https://github.com' # Modify this if using GH enterprise
  if [[ ! -z $1 && ! -z $2  ]]; then
    # User specified a repo
    git_url=$git_base_url/$1/$2
  elif git rev-parse --git-dir > /dev/null 2>&1; then
    # Use current repo
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
  else
    # Not in repo, and nothing specified, open homepage
    git_url=$git_base_url
  fi

  # Determine which open commands supported
  if hash open 2> /dev/null; then
    open_command=open
  elif hash xdg-open 2> /dev/null; then
    open_command=xdg-open
  elif hash lynx 2> /dev/null; then
    open_command=lynx
  elif hash w3m 2> /dev/null; then
    open_command=w3m
  else
    echo -e "\033[0;33mUnable to launch browser, open manually instead"
    echo -e "\033[1;96m🐙 GitHub URL: \033[0;96m\e[4m$git_url\e[0m"
    return;
  fi

  # Print messages
  echo -e "\033[1;96m🐙 Opening in browser: \033[0;96m\e[4m$git_url\e[0m"
  
  # And launch!
  $open_command $git_url
}

alias gho='open-github'