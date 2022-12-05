_setup_lessopen () {
    local hl=$(which lesspipe.sh 2>/dev/null)
    if [[ -z $hl ]]; then
        hl=$(which src-hilite-lesspipe.sh 2>/dev/null)
    fi
    if [[ -n $hl ]]; then
        export LESSOPEN="| $hl %s"
    fi
}

_setup_lessopen
