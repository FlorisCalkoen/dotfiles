# History
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY       # add timestamps
setopt HIST_EXPIRE_DUPS_FIRST # expire dupes first when trimming
setopt HIST_IGNORE_DUPS       # don't record duplicates
setopt HIST_IGNORE_SPACE      # skip commands starting with space
setopt SHARE_HISTORY          # share history across sessions

# Directory navigation
setopt AUTO_CD                # cd by typing directory name
setopt AUTO_PUSHD             # push dirs onto stack automatically
setopt PUSHD_IGNORE_DUPS

# Misc
setopt NO_BEEP
setopt INTERACTIVE_COMMENTS   # allow comments in interactive shell

# Vim-style keybindings
bindkey -v

# Custom keybindings
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
