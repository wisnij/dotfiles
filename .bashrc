_bashrc () {
    if [[ $- != *i* ]]; then
        # shell is non-interactive
        return
    fi

    if [[ -d $HOME/.config/bash/rc ]]; then
        local file
        for file in $HOME/.config/bash/rc/*.bash; do
            source "$file"
        done
    fi
}

_bashrc
