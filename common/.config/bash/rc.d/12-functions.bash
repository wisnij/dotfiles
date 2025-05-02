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


dups () {
    sort "$@" | uniq -c | sort -grs
}


find-large-files () {
    find "$@" -type f -printf '%s\t%p\n' | awk '{ if ($1 >= 1000000) print }' | sort -nr
}


perlmake () {
    perl Makefile.PL PREFIX="~/usr" LIB="~/usr/lib/perl5" "$@"
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


writeable() {
    find "$@" -type f -writable '!' -name '*~'
}
