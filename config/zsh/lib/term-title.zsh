#!/usr/bin/env zsh

# Configures Xterm's title
# For more information, see https://wiki.archlinux.org/index.php/Zsh#xterm_title

autoload -Uz add-zsh-hook

xterm-title-precmd() {
    print -Pn "\e]2;%n@%m %~\a"
    [[ "${TERM}" == "screen"* ]] && print -Pn "\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\"
}

xterm-title-preexec() {
    print -Pn "\e]2;%n@%m %~ %# " && print -n "${(q)1}\a"
    [[ "${TERM}" == "screen"* ]] && { print -Pn "\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# " && print -n "${(q)1}\e\\"; }
}

if [[ "${TERM}" == (screen*|xterm*|rxvt*) ]]; then
    add-zsh-hook -Uz precmd xterm-title-precmd
    add-zsh-hook -Uz preexec xterm-title-preexec
fi