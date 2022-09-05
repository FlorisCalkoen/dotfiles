# Dotfiles
Manage system configuration by creating symlinks in `$HOME` from a dotfiles directory
that is under version control. I'm using `$HOME/.dotfiles` as my `$DOTFILES_ROOT`, but
any other directory will also work. The symlink method is adopted from [Holman Does
Dotfiles](https://github.com/holman/dotfiles). 

## Conda

Minconda, including mamba, can be installed for both MacOS (M1, but also X86_64) and Linux by running:  
```bash
bash conda/install.sh
```

