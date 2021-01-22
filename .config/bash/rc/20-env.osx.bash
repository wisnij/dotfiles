export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH="$PATH:/usr/local/bin"
export MANPATH="$MANPATH:/usr/local/man"

if [[ $TERM == 'screen-256color' ]]; then
    export TERM=screen
fi

_osx_gnu () {
    # after "brew install coreutils findutils gawk gnu-getopt gnu-indent gnu-sed gnu-tar gnu-units gnutls grep"
    local package
    # XXX: removed gnu-sed to avoid incompatible differences vs built-in
    for package in coreutils findutils gawk gnu-indent gnu-tar gnu-units grep; do
        local dir="/usr/local/opt/$package/libexec/gnubin"
        if [[ -d $dir ]]; then
            export PATH="$dir:$PATH"
        fi
    done
}

_osx_gnu
