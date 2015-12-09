if [[ $- != *i* ]]; then
    # shell is non-interactive
    return
fi

if [[ -d $HOME/.config/bash/rc ]]; then
    for file in $HOME/.config/bash/rc/*.bash; do
        source "$file"
    done
fi
