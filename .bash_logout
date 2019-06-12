_bash_logout () {
    if [[ -d $HOME/.config/bash/logout ]]; then
        local file
        for file in $HOME/.config/bash/logout/*.bash; do
            source "$file"
        done
    fi
}

_bash_logout
