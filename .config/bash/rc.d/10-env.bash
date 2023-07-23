export COLUMNS
export HISTCONTROL='ignoredups:ignorespace'
export HISTFILESIZE=200000
export HISTSIZE=100000
export INPUTRC="$HOME/.config/readline/inputrc"
export LESS='-M -i -S -R'
export MANWIDTH=80
export PAGER='less'
export PATH="$HOME/.local/bin:$PATH"

# These are the defaults; exported here for easy reference
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

if type -t emacs >/dev/null; then
    EDITOR='emacs -nw'
else
    EDITOR='nano'
fi
export EDITOR
export VISUAL="$EDITOR"

if type -t lesspipe >/dev/null; then
    eval "$(lesspipe)"
elif [[ -x /usr/bin/lesspipe.sh ]]; then
    export LESSOPEN="|-/usr/bin/lesspipe.sh %s"
fi