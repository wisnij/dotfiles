# based on http://eli.thegreenplace.net/2013/06/11/keeping-persistent-history-in-bash

HISTTIMEFORMAT='[%Y-%m-%d %H:%M:%S] '
PERSISTENT_HISTORY_DIR=~/.local/share/bash
PERSISTENT_HISTORY_FILE=$PERSISTENT_HISTORY_DIR/persistent_history
PERSISTENT_HISTORY_LOCK=${PERSISTENT_HISTORY_FILE}.flock

persistent_history_append_log () {
    [[ $(history 1) =~ ^\ *[0-9]+\ +\[([^\]]+)\]\ +(.*)$ ]]
    local date="${BASH_REMATCH[1]}"
    local command="${BASH_REMATCH[2]//$'\n'/ }"

    mkdir -p $PERSISTENT_HISTORY_DIR

    (
        if type -t flock >/dev/null; then
            flock -x -w 60 200
        fi

        local last_num=0 last_command
        if [[ -e $PERSISTENT_HISTORY_FILE ]]; then
            if [[ $(tail -n1 $PERSISTENT_HISTORY_FILE) =~ ^\ *([0-9]+)\ +\[[^\]]+\]\ +(.*)$ ]]; then
                last_num="${BASH_REMATCH[1]}"
                last_command="${BASH_REMATCH[2]}"
            fi
        fi

        if [[ -n $command && $command != $last_command ]]; then
            if [[ ! -e $PERSISTENT_HISTORY_FILE ]]; then
                (umask g=,o=; touch $PERSISTENT_HISTORY_FILE)
            fi

            printf '%6d [%s] %s\n' $((last_num + 1)) "$date" "$command" >> $PERSISTENT_HISTORY_FILE
        fi
    ) 200>$PERSISTENT_HISTORY_LOCK
}

PROMPT_COMMAND="persistent_history_append_log;$PROMPT_COMMAND"

phistory () {
    local OPTION OPTARG OPTIND search recall
    while getopts 'g:r:' OPTION; do
        case $OPTION in
            g) search=$OPTARG ;;
            r) recall=$OPTARG ;;
        esac
    done
    shift $(($OPTIND - 1))

    if [[ -n $recall ]]; then
        local entry=$(grep "^ *$recall " $PERSISTENT_HISTORY_FILE)
        if [[ -z $entry ]]; then
            echo "history entry $recall not found"
            return 1
        elif [[ $entry =~ ^\ *[0-9]+\ +\[[^\]]+\]\ +(.*)$ ]]; then
            local command="${BASH_REMATCH[1]}"
            echo "recalling command: $command"
            history -s "$command"
        else
            echo "malformed history entry: $entry"
            return 2
        fi
    elif [[ -n $search ]]; then
        grep "$search" $PERSISTENT_HISTORY_FILE "$@"
    else
        tail -n ${1:-10} $PERSISTENT_HISTORY_FILE
    fi
}
