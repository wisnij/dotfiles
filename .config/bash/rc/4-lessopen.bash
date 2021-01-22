_setup_lessopen () {
    local hl=$(which lesspipe.sh)
    if [[ -z $hl ]]; then
        hl=$(which src-hilite-lesspipe.sh)
    fi
    if [[ -n $hl ]]; then
        export LESSOPEN="| $hl %s"
    fi
}

_setup_lessopen
