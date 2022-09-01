#!/usr/bin/env bash

# Helper functions for easily uploading file(s) or directory to transfer.sh
# To use a self-hosted instance, define the FILE_TRANSFER_SERVICE env var
# Can be either source'd then call`transfer` function, or invoked directly
# Licensed under MIT, (C) Alicia Sykes 2022: https://aliciasykes.com

# Once upload is complete, checks response is correct and prints to console
output_secret_link() {
  echo -e "\033[1;96m\nTransfer Complete 📤\033[0m"
  echo -e "\033[4;36m${1}\033[0m"
}

# Uploads file to file share service
transfer_file () {
  output_secret_link $(curl --upload-file $1 $FILE_TRANSFER_SERVICE)
}

# Combines files into an archive, uploads it, then removes
transfer_files () {
  zip $TMP_FILE $@
  output_secret_link $(curl --upload-file $TMP_FILE $FILE_TRANSFER_SERVICE)
  rm $TMP_FILE
}

# Zips directory up, uploads it, then removes it
transfer_directory () {
  zip -r $TMP_FILE $1
  output_secret_link $(curl --upload-file $TMP_FILE $FILE_TRANSFER_SERVICE)
  rm $TMP_FILE
}

# Determine the type of transfer, and call appropriate function
transfer () {
  FILE_TRANSFER_SERVICE="${FILE_TRANSFER_SERVICE:=https://transfer.sh}"
  if [[ $@ == *"--help" ]]; then
    transfer_help && return
  fi
  TMP_FILE="/tmp/file-transfer-$(date +%s).zip"
  if [ -z "$1" ]; then
    transfer_help
    return
  fi
  if [[ -f $1 ]] && [ "$#" -eq 1 ]; then
    transfer_file $@
  elif [ -d $1 ] && [ "$#" -eq 1 ]; then
    transfer_directory $@
  elif [ "$#" -gt 1 ]; then
    transfer_files $@
  fi
  unset TMP_FILE
}

# Shows usage instructions
transfer_help () {
  welcome_msg="\033[1;33mHelper script for transfering files via transfer.sh\n"
  welcome_msg="$welcome_msg\033[0;33mInvoke script with file(s) or a directory to upload\n"
  welcome_msg="$welcome_msg\033[1;33mE.g.\033[0;93m\n   $ transfer hello.txt\n"
  welcome_msg="$welcome_msg   $ transfer file1.txt file2.txt file3.txt\n   $ transfer my-folder/\n"
  echo -e $welcome_msg
}

# Determine if file is being run directly or sourced
([[ -n $ZSH_EVAL_CONTEXT && $ZSH_EVAL_CONTEXT =~ :file$ ]] || 
  [[ -n $KSH_VERSION && $(cd "$(dirname -- "$0")" &&
    printf '%s' "${PWD%/}/")$(basename -- "$0") != "${.sh.file}" ]] || 
  [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)) && sourced=1 || sourced=0

# If script being called directly, invoke transfer or show help
if [ $sourced -eq 0 ]; then
  if [ ! -n "${1+set}" ] || [[ $@ == *"--help"* ]]; then
    transfer_help
  else
    transfer $@
  fi
fi
