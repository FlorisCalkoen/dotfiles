#!/usr/bin/env bash
# Symlink VS Code settings and install extensions (macOS only)
if [[ "$(uname)" == "Darwin" ]] && command -v code &>/dev/null; then
  VSCODE_DIR="$HOME/Library/Application Support/Code/User"
  mkdir -p "$VSCODE_DIR"
  ln -sf "$HOME/.dotfiles/vscode/settings.json" "$VSCODE_DIR/settings.json"

  # Install extensions (skip comments and blank lines)
  while IFS= read -r ext; do
    ext="${ext%%#*}"
    ext="${ext// /}"
    [ -z "$ext" ] && continue
    code --install-extension "$ext" --force 2>/dev/null
  done < "$HOME/.dotfiles/vscode/extensions.txt"
fi