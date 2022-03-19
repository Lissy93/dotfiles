#!/usr/bin/env zsh

# Syntax highlighting for commands
antigen bundle zsh-users/zsh-syntax-highlighting

# Make and cd into nested directories
antigen bundle caarlos0/zsh-mkc

# Quickly jump into frequently used directories
antigen bundle agkozak/zsh-z

# Extra zsh completions
antigen bundle zsh-users/zsh-completions

# Auto suggestions from history
antigen bundle zsh-users/zsh-autosuggestions

# Pretty directory listings with git support
antigen bundle supercrabtree/k

# Quickly jump into fequently used directories
# antigen bundle autojump

# Syntax highlighting for cat
antigen bundle colorize

# Tell antigen that you're done
antigen apply