_dircolors_init () {
    if type -t dircolors >/dev/null; then
        local confdir=$HOME/.config/dircolors
        if [[ -f $confdir/dircolors ]]; then
            local dircolors_cmd=$(dircolors -b $confdir/dircolors 2>/dev/null)
            if [[ $? -ne 0 && -f $confdir/dircolors-old ]]; then
                dircolors_cmd=$(dircolors -b $confdir/dircolors-old)
            fi

            if [[ -n $dircolors_cmd ]]; then
                eval "$dircolors_cmd"
            fi
        fi
    fi
}

_dircolors_init
