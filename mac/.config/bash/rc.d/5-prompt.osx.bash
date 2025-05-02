_mac_titlebar_prompt () {
    case $TERM in
        screen*)
            return
            ;;
    esac

    local dir=$(dir-title -s)
    echo -ne "\033];$dir\007"
}

PROMPT_COMMAND="${PROMPT_COMMAND}_mac_titlebar_prompt"
