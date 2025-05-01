# dotfiles

These configuration files and user scripts are intended to be managed with
[GNU Stow](https://www.gnu.org/software/stow/).  To set up on a new system:

```bash
git clone git@github.com:wisnij/dotfiles.git
cd dotfiles/stow

# common settings
stow common

# system-specific settings (optional)
stow linux
stow mac
```
