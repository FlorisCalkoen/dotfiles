# Dotfiles

System configuration managed with symlinks and topic folders.

## Install

```bash
git clone https://github.com/YOURUSERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
script/install
```

## How it works

### Conventions

| Pattern | Behavior |
|---------|----------|
| `topic/` | A folder grouping related config (git, zsh, python, etc.) |
| `*.symlink` | Symlinked to `$HOME/.{name}` by `script/bootstrap` |
| `*.zsh` | Auto-sourced by the shell (see loading order below) |
| `install.sh` | Run by `script/install` for topic-specific setup |
| `bin/` | Added to `$PATH` — any script here becomes a command |
| `local/*.zsh` | Gitignored machine-specific overrides |

### Shell loading order

`zsh/zshrc.symlink` auto-sources all `*.zsh` files from topic folders in this order:

1. `**/path.zsh` — PATH modifications (loaded first)
2. `**/*.zsh` — everything except path.zsh and completion.zsh
3. `**/completion.zsh` — completion setup (loaded last)
4. `local/*.zsh` — machine-specific overrides
5. Starship prompt init

### Two entry points

- **`script/bootstrap`** — Symlinks files, sets up git config. Safe to re-run.
- **`script/install`** — Runs `brew bundle` and all topic `install.sh` scripts.

### Adding a new topic

Create a folder (e.g. `docker/`), add any of:
- `aliases.zsh` — aliases, auto-sourced
- `path.zsh` — PATH additions, loaded first
- `completion.zsh` — completions, loaded last
- `something.symlink` — symlinked to `~/.something`
- `install.sh` — run during `script/install`

### XDG-style configs

Configs that live in `~/.config/` (Ghostty, Starship) use a topic `install.sh`
to create the symlink instead of the `*.symlink` convention.

### Local overrides

Machine-specific config goes in `local/*.zsh` (gitignored). Example:

```bash
# local/work.zsh
export WORK_API_KEY="..."
export PATH="$HOME/work-tools/bin:$PATH"
```
