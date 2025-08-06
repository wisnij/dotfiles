if type -t git >/dev/null; then
    alias gd='git d'
    alias gds='git ds'
    alias gg='git g'

    smart-clone () {
        local dir=$(git smart-clone "$@")
        if [[ -n $dir ]]; then
            cd "$dir"
        fi
    }
fi
