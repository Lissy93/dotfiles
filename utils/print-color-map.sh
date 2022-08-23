#!/usr/bin/env bash

trap 'tput sgr0' exit # Clean up even if user hits ^C

function setfg () {
    printf '\e[38;5;%dm' $1
}
function setbg () {
    printf '\e[48;5;%dm' $1
}
function showcolors() {
    # Given an integer, display that many colors 
    for ((i=0; i<$1; i++))
    do
	printf '%4d ' $i
	setbg $i
	tput el
	tput sgr0
	echo
    done
    tput sgr0 el
}


### Main starts here

# First, test if terminal supports OSC 4 at all.
printf '\e]4;%d;?\a' 0
read -d $'\a' -s -t 0.1 </dev/tty
if [ -z "$REPLY" ]
then
    # OSC 4 not supported, so we'll fall back to terminfo 
    max=$(tput colors)
else
    # OSC 4 is supported, so use it for a binary search 
    min=0
    max=256
    while [[ $((min+1)) -lt $max ]]
    do
        i=$(( (min+max)/2 ))
        printf '\e]4;%d;?\a' $i
        read -d $'\a' -s -t 0.1 </dev/tty
        if [ -z "$REPLY" ]; then
            max=$i
        else
            min=$i
        fi
    done
fi


# If -v is given, show all the colors
case ${1-none} in none)
	echo $max;;-v)
	showcolors $max;;*)
	if [[ "$1" -gt 0 ]]; then
        showcolors $1
	else
        echo $max
	fi
	;;

esac | less --raw-control-chars --QUIT-AT-EOF --no-init