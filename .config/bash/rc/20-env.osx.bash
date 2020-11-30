export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH="$PATH:/usr/local/bin"
export MANPATH="$MANPATH:/usr/local/man"

if [[ $TERM == 'screen-256color' ]]; then
    export TERM=screen
fi
