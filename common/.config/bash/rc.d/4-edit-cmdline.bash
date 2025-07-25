# adapted from https://superuser.com/a/1601690

_edit_without_executing() {
    local editor="${EDITOR:-nano}"
    local tmpf="$(mktemp)"
    printf '%s\n' "$READLINE_LINE" > "$tmpf"
    $editor "$tmpf"
    READLINE_LINE="$(<"$tmpf")"
    if [[ ${BASH_VERSINFO[0]} -le 4 ]]; then
        READLINE_POINT="$(printf '%s' "$READLINE_LINE" | wc --bytes)"
    else
        READLINE_POINT="${#READLINE_LINE}"
    fi
    command rm -f "$tmpf"
}

if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    # custom editing with READLINE_* was only introduced in bash 4.0
    bind -x '"\C-x\C-e":_edit_without_executing'
fi
