if type -t dircolors >/dev/null; then
    if [[ -f $HOME/.config/dircolors ]]; then
        eval "$(dircolors -b $HOME/.config/dircolors)"
    fi
fi
