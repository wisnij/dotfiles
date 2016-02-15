if type -t dircolors >/dev/null; then
    if [[ -f $HOME/.config/dircolors ]]; then
        dircolors_cmd=$(dircolors -b $HOME/.config/dircolors 2>/dev/null)
        if [[ $? -ne 0 ]]; then
            dircolors_cmd=$(dircolors -b $HOME/.config/dircolors-old)
        fi

        if [[ -n $dircolors_cmd ]]; then
            eval "$dircolors_cmd"
        fi
    fi
fi
