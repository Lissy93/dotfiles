#  ~/.zlogin

# Compile .zcompdump file, if modified, to increase startup speed
# Executed on startin the background, so won't afftect current session
# Credit @htr3n. More info: https://htr3n.github.io/2018/07/faster-zsh/
{
    zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]];
    then
        zcompile "$zcompdump"
    fi
} &!
