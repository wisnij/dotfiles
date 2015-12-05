Adapted from https://github.com/nfarrar/dotfiles

The dotfiles are stored in separate branches and intended to be managed by [vcsh](https://github.com/RichiH/vcsh). To set up on a new system:

```bash
# common settings
vcsh clone -b common https://github.com/wisnij/dotfiles.git dotfiles

# system-specific settings (optional)
vcsh clone -b cygwin https://github.com/wisnij/dotfiles.git dotfiles-cygwin
vcsh clone -b linux  https://github.com/wisnij/dotfiles.git dotfiles-linux
vcsh clone -b osx    https://github.com/wisnij/dotfiles.git dotfiles-osx
# ...
```
