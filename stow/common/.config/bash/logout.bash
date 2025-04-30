# commands to run when a login shell exits

_bash_logout () {
    local confdir=$HOME/.config/bash

    if [[ -d $confdir/logout.d ]]; then
        local file
        for file in $confdir/logout.d/*.bash; do
            source "$file"
        done
    fi
}

_bash_logout
