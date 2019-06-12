_alias_ls () {
    if ! ls --help >/dev/null 2>&1; then
        local lsopts='-AFG'
        local lsopts_long='-lT'

        alias  l="ls $lsopts $lsopts_long -h"
        alias ll="ls $lsopts $lsopts_long"
        alias ls="ls $lsopts"
    fi
}

_alias_ls
