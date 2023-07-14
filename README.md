Adapted from https://github.com/nfarrar/dotfiles

The dotfiles are stored in separate branches and intended to be managed by
[vcsh](https://github.com/RichiH/vcsh).  Some of them also depend on the utilities in
[utils](https://github.com/wisnij/utils).  To set up on a new system:

```bash
# common settings
vcsh clone -b common git@github.com:wisnij/dotfiles.git dotfiles

# system-specific settings (optional)
vcsh clone -b linux  git@github.com:wisnij/dotfiles.git dotfiles-linux
vcsh clone -b osx    git@github.com:wisnij/dotfiles.git dotfiles-osx
# ...

# optional, but recommended
vcsh foreach config status.showUntrackedFiles no
```
