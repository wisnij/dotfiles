export IPYTHONDIR=$HOME/.config/ipython
export PYTHONDONTWRITEBYTECODE=1

# use aliases to always point to python3 on the command line without confusing any scripts that
# still assume 'python' means py2
alias python=python3
alias pydoc=pydoc3
alias ipython=ipython3

if type -t pyenv >/dev/null; then
    export PYENV_ROOT=$HOME/.pyenv
    eval "$(pyenv init -)"
fi
