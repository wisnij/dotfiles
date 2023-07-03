_mac_titlebar_prompt () {
    case $TERM in
        screen*)
            return
            ;;
    esac

    local dir=$PWD
    if git rev-parse --is-inside-work-tree >/dev/null; then
        dir=$(basename $(git rev-parse --show-toplevel))
    else
        if [[ ${BASH_VERSINFO} -ge 4 ]]; then
            dir="${dir/$HOME/\~}"
        else
            dir="${dir/$HOME/~}"
        fi
        if [[ $TERM_PROGRAM == 'iTerm.app' ]]; then
            # shorten to fit in tabs
            dir=$(sed -E -e 's/([^\/])[^\/]*\//\1\//g' <<<"$dir")
        fi
    fi
    echo -ne "\033];$dir\007"
}

PROMPT_COMMAND="${PROMPT_COMMAND}_mac_titlebar_prompt"
