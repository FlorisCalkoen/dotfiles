# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias d="cd ~/dev"
alias prd="cd ~/protondrive"

# Listing
alias l="ls -CF"
alias ll="ls -lah"
alias la="ls -A"

# Always color
alias grep='grep --color=auto'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Neovim
alias vim='nvim'

# Shortcuts
alias reload='source ~/.zshrc'

# Recursively delete .DS_Store
alias cleanup="find . -type f -name '.DS_Store' -ls -delete"
