_titlebar_prompt () {
    local dir="${PWD/$HOME/~}"
    if [[ $TERM_PROGRAM == 'iTerm.app' ]]; then
        # shorten to fit in tabs
        dir=$(sed -E -e 's/^.+(.{16})$/...\1/' <<<"$dir")
    fi
    echo -ne "\033];$dir\007"
}
