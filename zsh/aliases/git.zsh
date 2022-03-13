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
