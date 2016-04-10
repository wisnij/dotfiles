lsopts='-F --color=auto'
lsopts_long='-l --time-style="+%Y-%m-%d %H:%M:%S"'
if ls --help 2>/dev/null | grep -q group-directories-first; then
    lsopts="$lsopts --group-directories-first"
fi

alias  l="ls $lsopts $lsopts_long --si"
alias ll="ls $lsopts $lsopts_long"
alias ls="ls $lsopts"

alias  la='l -A'
alias lla='ll -A'

le () {
    l --color "$@" | egrep -v '^-r-.r-.r-.'
}

alias cp='cp -vi'
alias crontab='crontab -i'
alias egrep='egrep --color=auto'
alias grep='grep --color=auto'
alias hex='hexdump -C'
alias mv='mv -vi'
alias rm='rm -v'
alias rmdir='rmdir -v'
alias swapd='pushd'
alias taillog='tail -F -n +0'
alias type='type -a'
alias units='units -v'
alias whom='ps uxwf'
