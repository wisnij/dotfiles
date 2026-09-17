if type -t git >/dev/null; then
    alias gd='git d'
    alias gds='git ds'
    alias gg='git g'

    cdup () {
        # cd to repo root directory
        cd "$(git rev-parse --show-toplevel)"
    }

    smart-clone () {
        # smart clone and then cd to that directory
        local dir=$(git smart-clone "$@")
        if [[ -n $dir ]]; then
            cd "$dir"
        fi
    }
fi
