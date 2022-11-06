#!/usr/bin/env zsh

# Configure history file.
HISTFILE="${XDG_CACHE_HOME}/zsh/history"
HISTSIZE=50000
SAVEHIST=10000

# History command configuration.
setopt extended_history       # Record timestamp of command in $HISTFILE.
setopt hist_expire_dups_first # Delete duplicates first when $HISTFILE size exceeds $HISTSIZE.
setopt hist_ignore_dups       # Ignore duplicated commands in history list.
setopt hist_save_no_dups      # Do not save duplicates in history file.
setopt hist_find_no_dups      # Ignore duplicates when searching in history.
setopt hist_ignore_space      # Ignore commands that start with a space.
setopt hist_reduce_blanks     # Remove superfluous blanks from history items.
setopt hist_verify            # Show command with history expansion to user before running it.
setopt inc_append_history     # Add commands to $HISTFILE in order of execution.
setopt share_history          # Share history between different instances of the shell. 