#!/usr/bin/env zsh

# Use wider color range
export TERM=xterm-256color

# Enable dircolors.
if type -p dircolors &>/dev/null; then
    #  Enable custom colors if it exists.
    [ -e "${XDG_CONFIG_HOME}/dircolors" ] && \
    eval "$(dircolors -b "${XDG_CONFIG_HOME}/dircolors")" || \
    eval "$(dircolors -b)"
fi


# Add auto color to certain commands
# alias vdir="vdir --color=auto"      # Colorize 'vdir' command.
# alias grep="grep --color=auto -i"   # Colorize 'grep' command and ignore case.
# alias fgrep="grep --color=auto -i"  # Colorize 'fgrep' command and ignore case.
# alias egrep="grep --color=auto -i"  # Colorize 'egrep' command and ignore case.
# alias diff="diff --color=auto"      # Colorize 'diff' command.

# Color strings for basic file types
# FILE 01;34 # regular file
# RESET 0 # reset to "normal" color
# DIR 01;37 # directory
# LINK 01;36 # symbolic link
# MULTIHARDLINK 00 # reg file with more than one link
# FIFO 40;33 # pipe
# SOCK 01;35 # socket
# DOOR 01;35 # door
# BLK 40;33;01 # block device driver
# CHR 40;33;01 # character device driver
# ORPHAN 40;31;01 # symlink to nonexistent file, or non-stat'able file ...
# MISSING 00 # ... and the files they point to
# SETUID 37;41 # file that is setuid (u+s)
# SETGID 30;43 # file that is setgid (g+s)
# CAPABILITY 30;41 # file with capability
# STICKY_OTHER_WRITABLE 01;42 # dir that is sticky and other-writable (+t,o+w)
# OTHER_WRITABLE 01;32 # dir that is other-writable (o+w) and not sticky
# STICKY 37;44 # dir with the sticky bit set (+t) and not other-writable
# EXEC 01;32 # Files with execute permission

# Executables
# .cmd 01;32
# .exe 01;32
# .com 01;32
# .btm 01;32
# .bat 01;32
# .sh 01;32
# .csh 01;32

# Archives
# .tar 01;31
# .tgz 01;31
# .arc 01;31
# .arj 01;31
# .taz 01;31
# .lha 01;31
# .lz4 01;31
# .lzh 01;31
# .lzma 01;31
# .tlz 01;31
# .txz 01;31
# .tzo 01;31
# .t7z 01;31
# .zip 01;31
# .z 01;31
# .Z 01;31
# .dz 01;31
# .gz 01;31
# .lrz 01;31
# .lz 01;31
# .lzo 01;31
# .xz 01;31
# .zst 01;31
# .tzst 01;31
# .bz2 01;31
# .bz 01;31
# .tbz 01;31
# .tbz2 01;31
# .tz 01;31
# .deb 01;31
# .rpm 01;31
# .jar 01;31
# .war 01;31
# .ear 01;31
# .sar 01;31
# .rar 01;31
# .alz 01;31
# .ace 01;31
# .zoo 01;31
# .cpio 01;31
# .7z 01;31
# .rz 01;31
# .cab 01;31
# .wim 01;31
# .swm 01;31
# .dwm 01;31
# .esd 01;31

# Images
# .jpg 01;35
# .jpeg 01;35
# .mjpg 01;35
# .mjpeg 01;35
# .gif 01;35
# .bmp 01;35
# .pbm 01;35
# .pgm 01;35
# .ppm 01;35
# .tga 01;35
# .xbm 01;35
# .xpm 01;35
# .tif 01;35
# .tiff 01;35
# .png 01;35
# .svg 01;35
# .svgz 01;35
# .mng 01;35
# .pcx 01;35
# .mov 01;35
# .mpg 01;35
# .mpeg 01;35
# .m2v 01;35
# .mkv 01;35
# .webm 01;35
# .ogm 01;35
# .mp4 01;35
# .m4v 01;35
# .mp4v 01;35
# .vob 01;35
# .qt 01;35
# .nuv 01;35
# .wmv 01;35
# .asf 01;35
# .rm 01;35
# .rmvb 01;35
# .flc 01;35
# .avi 01;35
# .fli 01;35
# .flv 01;35
# .gl 01;35
# .dl 01;35
# .xcf 01;35
# .xwd 01;35
# .yuv 01;35
# .cgm 01;35
# .emf 01;35
# .ogv 01;35
# .ogx 01;35

# Audio
# .aac 00;36
# .au 00;36
# .flac 00;36
# .m4a 00;36
# .mid 00;36
# .go 00;33
# .php 00;33
# .midi 00;36
# .mka 00;36
# .mp3 00;36
# .mpc 00;36
# .ogg 00;36
# .ra 00;36
# .wav 00;36
# .oga 00;36
# .opus 00;36
# .spx 00;36
# .xspf 00;36
