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

| Pattern       | Behavior                                                  |
| ------------- | --------------------------------------------------------- |
| `topic/`      | A folder grouping related config (git, zsh, python, etc.) |
| `*.symlink`   | Symlinked to `$HOME/.{name}` by `script/bootstrap`        |
| `*.zsh`       | Auto-sourced by the shell (see loading order below)       |
| `install.sh`  | Run by `script/install` for topic-specific setup          |
| `bin/`        | Added to `$PATH` — any script here becomes a command      |
| `local/*.zsh` | Gitignored machine-specific overrides                     |

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

## macOS Manual Setup

After running `macos/defaults.sh`, apply these settings manually:

### Apple ID & iCloud

- System Settings → [your name]
  - Sign in with your primary Apple ID
  - iCloud → Photos
    - Enable iCloud Photos
    - Enable “Optimize Mac Storage” (recommended)
  - iCloud → Find My
    - Enable “Find My Mac”
    - Enable “Find My network”

### Location Services (Required for Find My)

- System Settings → Privacy & Security → Location Services
  - Location Services: **ON**
  - System Services → Details:
    - Find My: **ON**
    - Significant Locations: **ON** (recommended)

### Display (Deterministic Setup)

- System Settings → Displays
  - True Tone: **OFF**
  - Automatically adjust brightness: **OFF**
- System Settings → Displays → Night Shift
  - Schedule: **ON** sunset-based

### Accessibility (Optional / Not Scripted)

- System Settings → Accessibility
  - Zoom: Use scroll gesture with modifier key to zoom (optional)
    - Modifier key: Control (if enabled)
  - Display:
    - Reduce motion: optional
    - Reduce transparency: optional

### Safari (Managed via iCloud)

_Do not configure via dotfiles. Settings sync via iCloud._

- Safari → Settings:
  - Show full website address: **ON**
  - Auto-open safe downloads: **OFF**
  - Search engine suggestions: **OFF** (optional)
  - AutoFill:
    - Contacts: **OFF**
    - Credit cards: **OFF**
    - Passwords: **ON**
  - Enable fraud warnings: **ON**
  - Block pop-ups: **ON**

### Security & Privacy

- System Settings → Privacy & Security
  - FileVault: **ON**
  - Firewall: **ON** (optional, recommended)

### Notifications

- System Settings → Notifications
  - Disable unnecessary app notifications
  - Keep system notifications minimal

### Time Machine

- System Settings → General → Time Machine
  - Configure backup disk
  - Automatic backups: **Off**

### Final Check

- Confirm Find My Mac appears in Find My app
- Confirm iCloud sync is working (Photos, Contacts, etc.)

#### Enable (interactive)

- Messages → Banners + Sound
- Calendar → Banners
- Find My → Banners + Sound

#### Passive (no interruptions)

- Mail → Badges only
- Photos → Off or Badges only
- App Store → Off or Badges only

#### Disable (default)

- All other apps → OFF

#### Global

- Allow when locked → OFF
- Allow when mirroring → OFF
- Sounds → OFF for most apps

#### Focus Modes

- Work → allow Messages (selected people), Calendar
- Deep Work → allow nothing
