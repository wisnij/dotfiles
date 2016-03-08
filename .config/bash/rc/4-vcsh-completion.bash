#!/bin/bash

VCSH_COMMANDS="clone commit delete enter help init list list-tracked
    list-untracked pull push rename run status upgrade version which
    write-gitignore"

_vcsh_complete () {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"

    local repos=$(vcsh list)
    case $prev in
        vcsh)
            COMPREPLY=( $(compgen -W "$VCSH_COMMANDS $repos" -- "$cur") )
            ;;
        delete|enter|init|list-tracked|list-untracked|rename|run|status|upgrade)
            COMPREPLY=( $(compgen -W "$repos" -- "$cur") )
            ;;
        *)
            COMPREPLY=( $(compgen -f -X "*~" -- "$cur") )
            ;;
    esac
    return 0
}

complete -o filenames -F _vcsh_complete vcsh
