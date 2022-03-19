#!/usr/bin/env bash

# Helper functions for easily uploading file(s) or directory to transfer.sh
# To use a self-hosted instance, define the FILE_TRANSFER_SERVICE env var
# Can be either source'd then call`transfer` function, or invoked directly
# Licensed under MIT, (C) Alicia Sykes 2022: https://aliciasykes.com

# Uploads file to file share service
transfer-file () {
  curl --upload-file $1 $FILE_TRANSFER_SERVICE
}

# Combines files into an archive, uploads it, then removes
transfer-files () {
  zip $TMP_FILE $@
  curl --upload-file $TMP_FILE $FILE_TRANSFER_SERVICE
  rm $TMP_FILE
}

# Zips directory up, uploads it, then removes it
transfer-directory () {
  zip -r $TMP_FILE $1
  curl --upload-file $TMP_FILE $FILE_TRANSFER_SERVICE
  rm $TMP_FILE
}

# Determine the type of transfer, and call appropriate function
transfer () {
  FILE_TRANSFER_SERVICE="${FILE_TRANSFER_SERVICE:=https://transfer.sh}"
  TMP_FILE="/tmp/file-transfer-$(date +%s).zip"
  if [ -z "$1" ]; then
    transfer-help
    return
  fi
  if [[ -f $1 ]] && [ "$#" -eq 1 ]; then
    transfer-file $@
  elif [ -d $1 ] && [ "$#" -eq 1 ]; then
    transfer-directory $@
  elif [ "$#" -gt 1 ]; then
    transfer-files $@
  fi
  unset TMP_FILE
}

# Shows usage instructions
transfer-help () {
  echo "Helper script for transfering files via transfer.sh"
  echo "Invoke script with file(s) or a directory to upload"
  echo -e "E.g.\n   $ transfer hello.txt\n   $ transfer file1.txt file2.txt file3.txt\n   $ transfer my-folder/\n"
}

# Determine if file is being run directly or sourced
([[ -n $ZSH_EVAL_CONTEXT && $ZSH_EVAL_CONTEXT =~ :file$ ]] || 
 [[ -n $KSH_VERSION && $(cd "$(dirname -- "$0")" &&
    printf '%s' "${PWD%/}/")$(basename -- "$0") != "${.sh.file}" ]] || 
 [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)) && sourced=1 || sourced=0

# If script being called directly, invoke transfer or show help
if [ $sourced -eq 0 ]; then
  if [ ! -n "${1+set}" ] || [[ $@ == *"--help"* ]]; then
    transfer-help
  else
    transfer $@
  fi
fi
