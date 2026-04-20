# Case-insensitive completion, then substring match, then fuzzy
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'l:|=* r:|=*' \
  'r:|[._-]=** l:|=*'

# Use menu selection for completions
zstyle ':completion:*' menu select

# Color completions like ls
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
