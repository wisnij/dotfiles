if [[ -d $HOME/.config/bash/logout ]]; then
    for file in $HOME/.config/bash/logout/*.bash; do
        source "$file"
    done
fi
