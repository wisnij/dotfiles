# based on http://eli.thegreenplace.net/2013/06/11/keeping-persistent-history-in-bash

HISTTIMEFORMAT='[%Y-%m-%d %H:%M:%S] '
PERSISTENT_HISTORY_DIR=~/.local/share/bash
PERSISTENT_HISTORY_FILE=$PERSISTENT_HISTORY_DIR/persistent_history

persistent_history_append_log () {
    [[ $(history 1) =~ ^\ *[0-9]+\ +(\[[^\]]+\]+)\ +(.*)$ ]]
    local date="${BASH_REMATCH[1]}"
    local command="${BASH_REMATCH[2]}"
    if [[ $command != $PERSISTENT_HISTORY_LAST ]]; then
        mkdir -p $PERSISTENT_HISTORY_DIR
        if [[ ! -e $PERSISTENT_HISTORY_FILE ]]; then
            (umask g=,o=; touch $PERSISTENT_HISTORY_FILE)
        fi
        echo "$date $command" >> $PERSISTENT_HISTORY_FILE
        PERSISTENT_HISTORY_LAST=$command
    fi
}

PROMPT_COMMAND="persistent_history_append_log;$PROMPT_COMMAND"

phgrep () {
    grep "$@" $PERSISTENT_HISTORY_FILE
}
