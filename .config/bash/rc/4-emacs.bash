alias emacs='emacs -nw'

unalias xemacs 2>/dev/null
xemacs () {
    if [[ -f $HOME/.ssh/last_connection_init ]]; then
        source $HOME/.ssh/last_connection_init
    fi
    
    if type -t emacsclient >/dev/null; then
        emacsclient -a '' -n -c "$@"
    else
        'emacs' "$@" &
        disown
    fi
}

emacsnw () {
    if type -t emacsclient >/dev/null; then
        emacsclient -a '' -t "$@"
    else
        'emacs' -nw "$@"
    fi
}
