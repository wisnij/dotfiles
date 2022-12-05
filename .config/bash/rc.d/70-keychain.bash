if type -t keychain >/dev/null; then
    keychain id_rsa id_dsa --host $HOSTNAME --ignore-missing --quiet
    
    keyfile=$HOME/.keychain/${HOSTNAME}-sh
    if [[ -f "$keyfile" ]]; then
        source "$keyfile" >/dev/null
    fi
fi
