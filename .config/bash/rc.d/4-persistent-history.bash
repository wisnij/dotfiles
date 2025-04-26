# based on http://eli.thegreenplace.net/2013/06/11/keeping-persistent-history-in-bash
# and https://www.jefftk.com/p/you-should-be-logging-shell-history

HISTTIMEFORMAT='[%Y-%m-%d %H:%M:%S] '
PERSISTENT_HISTORY_DIR=~/.local/share/bash
PERSISTENT_HISTORY_ENABLED=true
PERSISTENT_HISTORY_FILE=$PERSISTENT_HISTORY_DIR/persistent_history
PERSISTENT_HISTORY_LOCK=${PERSISTENT_HISTORY_FILE}.flock

persistent_history_append_log () {
    if ! $PERSISTENT_HISTORY_ENABLED; then
        return
    fi

    [[ $(history 1) =~ ^\ *[0-9]+\ +\[([^\]]+)\]\ +(.*)$ ]]
    local date="${BASH_REMATCH[1]}"
    local command="${BASH_REMATCH[2]//$'\n'/ }"

    local dir
    if [[ -e $PS0_STATE_FILE ]]; then
        dir=$(grep '^pwd ' "$PS0_STATE_FILE" | sed -e 's/^pwd //')
    else
        dir=$PWD
    fi
    dir=$(printf '%q' "$dir")
    dir=${dir/#$HOME/\~}

    mkdir -p $PERSISTENT_HISTORY_DIR

    (
        if type -t flock >/dev/null; then
            flock -x -w 60 200
        fi

        local last_command
        if [[ -e $PERSISTENT_HISTORY_FILE ]]; then
            local last_line=$(tail -n1 $PERSISTENT_HISTORY_FILE)
            if [[ $last_line =~ ^\[[^\]]+\]\ +.*\ +\$\ +.*$ ]]; then
                last_command=${last_line#* \$ }
            elif [[ $last_line =~ ^\ *[0-9]+\ +\[[^\]]+\]\ +(.*)$ ]]; then
                last_command=${BASH_REMATCH[1]}
            fi
        fi

        if [[ -n $command && $command != $last_command ]]; then
            if [[ ! -e $PERSISTENT_HISTORY_FILE ]]; then
                (umask g=,o=; touch $PERSISTENT_HISTORY_FILE)
            fi

            printf '[%s] %s $ %s\n' "$date" "$dir" "$command" >> $PERSISTENT_HISTORY_FILE
        fi
    ) 200>$PERSISTENT_HISTORY_LOCK
}

PROMPT_COMMAND="persistent_history_append_log;$PROMPT_COMMAND"

phistory () {
    local OPTION OPTARG OPTIND enable fuzzy search
    while getopts 'defg:r:' OPTION; do
        case $OPTION in
            d) enable=false ;;
            e) enable=true ;;
            f) fuzzy=1 ;;
            g) search=$OPTARG ;;
        esac
    done
    shift $(($OPTIND - 1))

    if [[ -n $enable ]]; then
        PERSISTENT_HISTORY_ENABLED=$enable
        return
    fi

    local entry
    if [[ -n $fuzzy ]]; then
        if entry=$(fzf --tac --no-sort "$@" <$PERSISTENT_HISTORY_FILE); then :; else
            return $?
        fi
    elif [[ -n $search ]]; then
        grep "$search" "$@" $PERSISTENT_HISTORY_FILE
        return $?
    elif [[ $@ =~ ^[0-9] ]]; then
        tail -n "$@" $PERSISTENT_HISTORY_FILE
    else
        tail "$@" $PERSISTENT_HISTORY_FILE
    fi

    if [[ -n $entry ]]; then
        local command
        if [[ $entry =~ ^\[[^\]]+\]\ +.*?\ +\$\ +.*$ ]]; then
            command=${entry#* \$ }
        elif [[ $entry =~ ^\ *[0-9]+\ +\[[^\]]+\]\ +(.*)$ ]]; then
            command=${BASH_REMATCH[1]}
        fi

        if [[ -n $command ]]; then
            echo "recalling command: $command"
            history -s "$command"
        else
            echo "malformed history entry: '$entry'" >&2
            return 2
        fi
    fi
}

alias fh='phistory -f'
