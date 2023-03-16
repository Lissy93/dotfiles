#!/bin/sh -
# Quick utility to aid in keeping clutter down in the $HOME directory
# Lists statistics about number of files, auto-cleans certain files,
# and prompts user whether they'd like to each remaining dotfile in turn

set -u

readonly HOME=${HOME:-$(getent passwd "$(id -un)" | cut -d : -f 6)}

inlist() {
for e in $2; do
    case "$1" in ($e)
        return
    esac
done
false
}

die() {
    retval=$(($1)); shift
    { printf "$@"; echo; } >&2
    exit $retval
}

prompt_delete() {
    printf '\nDelete %s? [Y/n] ' "$1"
    read -r a
    test -t 0 || printf '\033[1;32m%s\033[0m\n' "$a"
    case "$a" in
        (''|Y*|y*) rm -rv "$1" ;;
        (N*|n*) ;;
        (*) prompt_delete "$1" ;;
    esac
}

# gather and show statistics:
n_nondots=$(find "$HOME" -maxdepth 1 -mindepth 1 -name '[^.]*' | wc -l)
n_dots=$(find "$HOME" -maxdepth 1 -mindepth 1 -name '.*' | wc -l)
n_all=$((n_nondots + n_dots))
cat <<- EOF
total:        $n_all
normal files: $n_nondots
$(printf '\033[1m')dotfiles:     $n_dots$(printf '\033[0m')

EOF

# List dotfiles:
cd "$HOME" || die 1 'Could not cd into home directory (%s)' "$HOME"
if ! ls -1d --color=auto .[!.]*; then
	die 1 'Could not list files in home directory (%s)' "$HOME"
fi

# Automatic decisions for specific files/directories:
keeplist='.anthy .local .pam_environment .pki .ssh'
deletelist='.ansible .ansible_galaxy .mozilla .w3m .*_history'

# delete:
for d in .*; do
    case "$d" in (.|..) continue ;; esac
    if inlist "$d" "$keeplist"; then
        # Do not delete this file
        continue
    elif inlist "$d" "$deletelist"; then
        # Delete this file without asking
        echo y | prompt_delete "$d"
        continue
    else
        # Ask the user if should delete or not
        prompt_delete "$d"
    fi
done