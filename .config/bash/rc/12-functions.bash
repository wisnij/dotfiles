# Display or create backup files with datestamps and optional descriptions
bak () {
    if [[ $# -eq 0 ]]; then
        l *.bak
        return
    fi

    local file=$1
    shift
    local slug
    if [[ $# -gt 0 ]]; then
        slug=$(sed -E -e 's/[^A-Za-z0-9_]+/-/g' <<< "-$*")
    fi
    local backup="$file.$(date +'%Y%m%d-%H%M%S')$slug.bak"
    cp -v "$file" "$backup"
}


bar () {
    local n=${1:-2}
    perl -le "print(qq(\e[1;33m) . ('#' x $COLUMNS) . qq(\e[0m)) for 1..$n"
}


bell () {
    for t in "$@" ''; do
        echo -ne '\a'
        if [[ -n $t ]]; then
            sleep $t
        fi
    done
}


cath () {
    for file in "$@"; do
        echo -e "\033[7m##### $file #####\033[0m"
        cat "$file"
    done
}


# from http://madebynathan.com/2011/10/04/a-nicer-way-to-use-xclip/
# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# - If the input is a filename that exists, then it
#   uses the contents of that file.
# ------------------------------------------------
cb () {
  local _scs_col="\033[0;32m"; local _wrn_col='\033[1;31m'; local _trn_col='\033[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\033[0m"
  # Check user is not root (root doesn't have access to user xorg server)
  elif [[ "$USER" == "root" ]]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\033[0m"
  else
    # If no tty, data should be available on stdin
    if ! [[ "$( tty )" == /dev/* ]]; then
      input="$(< /dev/stdin)"
    # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print usage message.
      echo "Copies a string or the contents of a file to the clipboard."
      echo "Usage: cb <string or file>"
      echo "       echo <string or file> | cb"
    else
      # If the input is a filename that exists, then use the contents of that file.
      if [ -e "$input" ]; then input="$(cat $input)"; fi
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\033[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\033[0m $input"
    fi
  fi
}


dups () {
    sort "$@" | uniq -c | sort -grs
}


find-large-files () {
    find "$@" -type f -printf '%s\t%p\n' | awk '{ if ($1 >= 1000000) print }' | sort -nr
}


perlmake () {
    perl Makefile.PL PREFIX="~/usr" LIB="~/usr/lib/perl5" "$@"
}


taillog () {
    tail -F "$@" | timestamp
}


timestamp () {
    local line
    while IFS= read -r line; do
        printf '\033[38;5;8m[%s]\033[0m %s\n' "$(date +'%F %T')" "$line"
    done
}


todo () {
    grep -E 'XXX|TODO|FIXME' "$@"
}


waitpid () {
    local pid=$1
    local seen=0
    while [[ -e /proc/$pid ]]; do
        sleep 1
        seen=1
    done
    if [[ $seen -eq 0 ]]; then
        echo "process $pid not found"
        return 2
    fi
}


writeable() {
    find "$@" -type f -writable '!' -name '*~'
}
