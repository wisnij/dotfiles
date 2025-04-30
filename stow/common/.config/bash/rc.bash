# commands to run when an interactive shell starts

_bashrc () {
    local confdir=$HOME/.config/bash

    if [[ $- != *i* ]]; then
        # shell is non-interactive
        return
    fi

    if [[ -d $confdir/rc.d ]]; then
        local file
        for file in $confdir/rc.d/*.bash; do
            source "$file"
        done
    fi
}

_bashrc
