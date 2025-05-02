pst () {
    pstree -g3 "$@" | less
}
