# commands to run when a login shell starts

_bash_login () {
    local confdir=$HOME/.config/bash

    if [[ -f $confdir/rc.bash ]]; then
        source $confdir/rc.bash
    fi

    if [[ -d $confdir/login.d ]]; then
        local file
        for file in $confdir/login.d/*.bash; do
            source "$file"
        done
    fi
}

_bash_login
