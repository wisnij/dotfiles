_titlebar_prompt () {
    local dir
    if [[ ${BASH_VERSINFO} -ge 4 ]]; then
        dir="${PWD/$HOME/\~}"
    else
        dir="${PWD/$HOME/~}"
    fi
    if [[ $TERM_PROGRAM == 'iTerm.app' ]]; then
        # shorten to fit in tabs
        dir=$(sed -E -e 's/([^\/])[^\/]*\//\1\//g' <<<"$dir")
    fi
    echo -ne "\033];$dir\007"
}
