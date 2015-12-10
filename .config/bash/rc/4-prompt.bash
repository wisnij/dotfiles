_prompt () {
    local status=$?

    local red="\[\e[01;31m\]"
    local green="\[\e[01;32m\]"
    local blue="\[\e[01;34m\]"
    local normal="\[\e[00m\]"

    local hostname=${HOSTNAME:-$(hostname)}
    local host_color
    if [[ -n $HOST_COLOR ]]; then
        host_color="\[\e[${HOST_COLOR}m\]"
    else
        # use CRC checksum to turn the hostname into a semi-unique integer
        local n=$(echo $hostname | cksum | cut -d' ' -f1)
        
        # fold into the 256color range 22-231
        local hc=$((22 + 10#$n % 210))
        host_color="\[\e[1;38;5;${hc}m\]"
    fi

    local prompt_color
    if [[ -n $PROMPT_COLOR ]]; then
        prompt_color="\[\e[${PROMPT_COLOR}m\]"
    elif [[ $USER == 'root' ]]; then
        prompt_color=$red
    else
        prompt_color=$green
    fi
    
    # basics: [time] user@host pwd
    PS1="${prompt_color}[\t] \u${normal}@${host_color}$hostname${normal} ${blue}\w${normal}"
    
    # show error statuses in red
    if [[ $status != 0 ]]; then
        PS1="$PS1 ${red}${status}${normal}"
    fi
    
    # number of active jobs if >0
    if [[ -n $(jobs) ]]; then
        PS1="$PS1 (\j)"
    fi
    
    # final prompt char
    PS1="$PS1 \$ "
    
    # set the window titlebar if we're in a term which can do that
    case $TERM in
        xterm*|rxvt*)
            echo -ne "\e]0;${USER}@${hostname}: ${PWD/$HOME/\~}\007"
            ;;
        screen)
            echo -ne "\ek$(echo ${PWD/$HOME/\~} | sed -re 's/^.+(.{17})$/...\1/')\e\\"
            ;;
    esac
}

export PROMPT_COMMAND=_prompt
