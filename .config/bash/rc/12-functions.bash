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
        slug=-$(sed -re 's/[^A-Za-z0-9_]+/-/g' <<< "$*")
    fi 
    local backup="$file.$(date +'%Y%m%d-%H%M%S')$slug.bak"
    cp -v "$file" "$backup"
}


bar () {
    local n=${1:-2}
    perl -le "print '#' x $COLUMNS for 1..$n"
}


cath () {
    for file in "$@"; do
        echo -e "\e[7m##### $file #####\e[0m"
        cat "$file"
    done
}


dups () {
    sort "$@" | uniq -c | sort -grs
}


find-large-files () {
    find -type f -printf '%s\t%p\n' | sort -nr
}


perlmake () {
    perl Makefile.PL PREFIX="~/usr" LIB="~/usr/lib/perl5" "$@"
}


todo () {
    grep -E 'XXX|TODO|FIXME' "$@"
}


writeable() {
    find "$@" -type f -writable '!' -name '*~'
}
