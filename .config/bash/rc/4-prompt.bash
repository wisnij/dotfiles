_titlebar_prompt () {
    # set the window titlebar if we're in a term which can do that
    case $TERM in
        xterm*|rxvt*)
            echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/\~}\007"
            ;;
        screen*)
            echo -ne "\033k$(echo ${PWD/$HOME/\~} | sed -E -e 's/^.+(.{17})$/...\1/')\033\\"
            ;;
    esac
}

_str_color () {
    local str=$1
    local n=$(echo $str | cksum | cut -d' ' -f1)

    # fold into the 256color range 22-231
    local c=$((22 + 10#$n % 210))
    echo "\[\033[1;38;5;${c}m\]"
}

_bash_prompt () {
    local status=$?

    local red="\[\033[01;31m\]"
    local green="\[\033[01;32m\]"
    local blue="\[\033[01;34m\]"
    local normal="\[\033[00m\]"

    local hostname=${HOSTNAME:-$(hostname)}
    hostname=${hostname%%.*}

    local host_color
    if [[ -n $HOST_COLOR ]]; then
        host_color="\[\033[${HOST_COLOR}m\]"
    else
        host_color=$(_str_color $hostname)
    fi

    local prompt_color
    if [[ -n $PROMPT_COLOR ]]; then
        prompt_color="\[\033[${PROMPT_COLOR}m\]"
    elif [[ $USER == 'root' ]]; then
        prompt_color=$red
    else
        prompt_color=$green
    fi

    # basics: [time] user@host pwd
    PS1="${prompt_color}[\t] \u${normal}@${host_color}$hostname${normal} ${blue}\w${normal}"

    # are we in a Python venv?
    if [[ -n $VIRTUAL_ENV ]]; then
        local venv=$(basename $VIRTUAL_ENV)
        PS1="$PS1 [$(_str_color $VIRTUAL_ENV)$venv$normal]"
    fi

    # git branch and status; __git_ps1 from git/contrib/completion/git-prompt.sh
    if type -t __git_ps1 >/dev/null; then
        GIT_PS1_SHOWDIRTYSTATE=true
        GIT_PS1_SHOWSTASHSTATE=true
        GIT_PS1_SHOWUNTRACKEDFILES=true
        GIT_PS1_SHOWUPSTREAM="auto"
        GIT_PS1_HIDE_IF_PWD_IGNORED=true
        GIT_PS1_SHOWCOLORHINTS=true

        local old_PS1=$PS1
        PS1=''
        if __git_ps1 "" "" "%s"; then
            jobs >/dev/null # dumb hack to clear out lingering git commands
        fi

        if [[ -n $PS1 ]]; then
            PS1="$old_PS1 ($PS1)"
        else
            PS1=$old_PS1
        fi
    fi

    # number of active jobs if >0
    if [[ -n $(jobs) ]]; then
        PS1="$PS1 (\j)"
    fi

    # show error statuses in red
    if [[ $status != 0 ]]; then
        PS1="$PS1 ${red}${status}${normal}"
    fi

    local prompt i
    for (( i=0; i < $SHLVL; ++i )); do
        prompt+="\\\$"
    done

    # final prompt char
    local sep
    if [[ $COLUMNS -lt 120 ]]; then
        sep="\n"
    else
        sep=" "
    fi
    PS1="$PS1$sep$prompt "
}

_prompt () {
    _bash_prompt
    _titlebar_prompt
}

PROMPT_COMMAND="_prompt;$PROMPT_COMMAND"
