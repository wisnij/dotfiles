if ! ls --help >/dev/null 2>&1; then
    lsopts='-AFG'
    lsopts_long='-lT'

    alias  l="ls $lsopts $lsopts_long -h"
    alias ll="ls $lsopts $lsopts_long"
    alias ls="ls $lsopts"
fi
