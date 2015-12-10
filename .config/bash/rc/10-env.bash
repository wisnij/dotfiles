export COLUMNS
export EDITOR='emacs -nw'
export HISTCONTROL='ignoredups'
export HISTFILESIZE=200000
export HISTSIZE=100000
export LESS='-M -i -S -R'
export MANPATH="$HOME/usr/share/man:$MANPATH"
export MANWIDTH=80
export MYSQL_PS1="\u@\h (\R:\m:\s) \d>\_"
export PAGER='less'
export PATH="$HOME/bin:$HOME/usr/bin:$PATH"
export PERL5LIB="$HOME/usr/lib/perl5:$PERL5LIB"
export SBCL_HOME="$HOME/usr/lib/sbcl"
export SCREENRC="$HOME/.config/screenrc"
export VISUAL="$EDITOR"

if [[ -x /usr/bin/lesspipe.sh ]]; then
    export LESSOPEN="|-/usr/bin/lesspipe.sh %s"
fi
