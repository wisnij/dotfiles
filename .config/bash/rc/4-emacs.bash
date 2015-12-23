emacs () {
    local term=$TERM
    if [[ $term == 'screen-256color' ]]; then
        term=xterm-256color
    fi

    env TERM=$term emacs -nw "$@"
}

unalias xemacs 2>/dev/null
xemacs () {
    if [[ -f $HOME/.ssh/last_connection_init ]]; then
        source $HOME/.ssh/last_connection_init
    fi
    
    if type -t emacsclient >/dev/null; then
        emacsclient -a '' -n -c "$@"
    else
        env emacs "$@" &
        disown
    fi
}

emacsnw () {
    local term=$TERM
    if [[ $term == 'screen-256color' ]]; then
        term=xterm-256color
    fi

    if type -t emacsclient >/dev/null; then
        env TERM=$term emacsclient -a '' -t "$@"
    else
        env TERM=$term emacs -nw "$@"
    fi
}
