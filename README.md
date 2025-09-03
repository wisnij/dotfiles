# dotfiles

These configuration files and user scripts are intended to be managed with
[GNU Stow](https://www.gnu.org/software/stow/).  To set up on a new system:

```bash
git clone git@github.com:wisnij/dotfiles.git
cd dotfiles

# common settings
stow common

# system-specific settings (optional)
stow linux
stow mac
...
```

## Why Stow?

I used to use [vcsh](https://github.com/RichiH/vcsh) for managing these
dotfiles, but later switched to Stow.

Upsides:

- All of my packages can exist in the same branch.  Moving a file from one
  package to another is as simple as `git mv`.  I can search across all packages
  with a single `git grep`.
- Cloning a repo and installing it are two separate steps, so all the files for
  all packages can be synced locally before running the install steps.  This is
  occasionally relevant for configuration files that modify how network
  operations happen, such as SSH configs.
- vcsh overlays all of its managed files into your home directory as the working
  tree of a git repo, which is clever but non-obvious outside of the `vcsh`
  tool.  Stow creates symlinks to the repo files, which is immediately obvious
  with a simple `ls -l` and can be discerned from the file itself, without
  having to reference a git repo somewhere else.  It also makes it easy to see
  which files in a directory are Stow-managed and which are not, and the
  specific package each file is associated with is visible in the symlink path.
- This also has the nice side effect that it's impossible to accidentally `git
  add` your entire home directory into vcsh like I did that one time.
- vcsh overlays the _entire_ repo file tree into your home dir, so the only
  place to store READMEs or other out-of-band files that shouldn't get installed
  is in a separate branch.  With Stow, the installable packages are in
  individual subdirectories, so files not associated with any of them can go at
  the repo root or elsewhere.
- Configuration options for Stow can go into the repo itself as
  [.stowrc](.stowrc) and be version-controlled alongside the package files.

Downsides:

- Persisting changes is slightly more cumbersome; I have to actually `cd` to the
  repo directory and `git add` any changes manually, rather than doing `vcsh
  REPONAME add` from wherever.
- Separate repos have to be managed separately, rather than through a single
  `vcsh` command as a unified interface.

For my use case this tradeoff is well worth it, but YMMV.
