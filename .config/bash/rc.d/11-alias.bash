_alias_ls () {
    local lsopts='-F --color=auto'
    local lsopts_long='-l --time-style="+%Y-%m-%d %H:%M:%S"'
    if ls --help 2>/dev/null | grep -q group-directories-first; then
        lsopts="$lsopts --group-directories-first"
    fi

    alias  l="ls $lsopts $lsopts_long --si"
    alias ll="ls $lsopts $lsopts_long"
    alias ls="ls $lsopts"

    alias  la='l -A'
    alias lla='ll -A'
}

_alias_ls

le () {
    l --color "$@" | egrep -v '^-r-.r-.r-.'
}

alias cp='cp -vi'
alias crontab='crontab -i'
alias egrep='egrep --color=auto'
alias grep='grep --color=auto'
alias hex='hexdump -C'
alias ln='ln -vi'
alias mv='mv -vi'
alias psf='ps fuxw'
alias rm='rm -v'
alias rmdir='rmdir -v'
alias swapd='pushd'
alias type='type -a'
alias units='units -v'
