unset PROMPT_COMMAND

export COLUMNS
export HISTCONTROL='ignoredups:ignorespace'
export HISTFILESIZE=200000
export HISTSIZE=100000
export INPUTRC="$HOME/.config/readline/inputrc"
export LESS='-M -i -S -R'
export MANPATH="$HOME/usr/share/man:$MANPATH"
export MANWIDTH=80
export MYSQL_PS1="\u@\h (\R:\m:\s) \d>\_"
export PAGER='less'
export PATH="$HOME/bin:$HOME/usr/bin:$HOME/.local/bin:$PATH"
export PERL5LIB="$HOME/usr/lib/perl5:$PERL5LIB"
export SBCL_HOME="$HOME/usr/lib/sbcl"

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
