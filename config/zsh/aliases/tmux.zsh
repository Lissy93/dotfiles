######################################################################
# ZSH aliases and helper functions for Tmux and common Tmux tasks    #
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
######################################################################

# Tmux shortcuts
alias tmux='tmux -u'
alias t='tmux'
alias ta='tmux attach-session -t'
alias tn='tmux new-session -s'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'

# Tmux helpers
function tsplit() {
  tmux split-window -v "$@"
}

function tvsplit() {
  tmux split-window -h "$@"
}

function tresize() {
  tmux resize-pane -D "$@"
}

function tresizeh() {
  tmux resize-pane -R "$@"
}

function tresizev() {
  tmux resize-pane -U "$@"
}

function tresizeleft() {
  tmux resize-pane -L "$@"
}

function tresizeup() {
  tmux resize-pane -U "$@"
}

function tresizedown() {
  tmux resize-pane -D "$@"
}

function tresizeup() {
  tmux resize-pane -U "$@"
}

function tresizeleft() {
  tmux resize-pane -L "$@"
}

function tresizeright() {
  tmux resize-pane -R "$@"
}
