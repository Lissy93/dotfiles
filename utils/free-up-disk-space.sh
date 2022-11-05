#!/bin/bash

######################################################################
# 📊 Free up disk space                                              #
######################################################################
# Series of commands for freeing up disk space on *nix based systems #
# Will ask for user permission before executing or deleting anything #
# Info about current disk usage is printed before starting           #
#                                                                    #
# Includes the following tasks:                                      #
# - Cleaning package cache for various package managers              #
# - Removing orphaned and unused packages and binaries               #
# - Setting logging preferences and removing old logs                #
# - Removing local cache files for the current user                  #
# - Deleting broken symlinks and empty files + folers                #
# - Finding and deleting duplicated large files                      #
#                                                                    #
# IMPORTANT: Before running, read through everything very carefully! #
# For docs and more info, see: https://github.com/lissy93/dotfiles   #
######################################################################
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
######################################################################
