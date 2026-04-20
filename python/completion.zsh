# uv shell completion
if command -v uv &>/dev/null; then
  eval "$(uv generate-shell-completion zsh 2>/dev/null || true)"
fi

# Conda/Miniforge (Homebrew cask installs to /opt/homebrew/Caskroom/miniforge/base)
_miniforge_base="/opt/homebrew/Caskroom/miniforge/base"
if [ -f "$_miniforge_base/etc/profile.d/conda.sh" ]; then
  source "$_miniforge_base/etc/profile.d/conda.sh"
  if [ -f "$_miniforge_base/etc/profile.d/mamba.sh" ]; then
    export MAMBA_ROOT_PREFIX="$_miniforge_base"
    source "$_miniforge_base/etc/profile.d/mamba.sh"
  fi
  conda activate base
fi
unset _miniforge_base
