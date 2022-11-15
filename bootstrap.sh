#!/usr/bin/env bash
#
# bootstrap installs things.

cd "$(dirname "$0")"
DOTFILES_ROOT=$(pwd -P)
echo "$DOTFILES_ROOT"
set -e

echo ''

info() {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user() {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

setup_gitconfig() {
  if ! [ -f git/gitconfig.local.symlink ]; then
    info 'setup gitconfig'

    git_credential='cache'
    if [ "$(uname -s)" == "Darwin" ]; then
      echo "osxkeychain can be used on macs, but is not configured yet. "
      # git_credential='osxkeychain'
    fi

    user ' - What is your github author name?'
    read -e git_authorname
    user ' - What is your github author email?'
    read -e git_authoremail

    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" git/gitconfig.local.symlink.example >git/gitconfig.local.symlink

    success 'gitconfig'
  fi
}

link_file() {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]; then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]; then

        skip=true

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
        o)
          overwrite=true
          ;;
        O)
          overwrite_all=true
          ;;
        b)
          backup=true
          ;;
        B)
          backup_all=true
          ;;
        s)
          skip=true
          ;;
        S)
          skip_all=true
          ;;
        *) ;;

        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]; then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]; then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]; then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]; then # "false" or empty
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

install_dotfiles() {
  info 'installing dotfiles'

  local overwrite_all=false backup_all=false skip_all=false

  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*' -not -path "$DOTFILES_ROOT/vscode/*"); do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}

install_user_bin() {

  local overwrite_all=false backup_all=false skip_all=false

  info "installing scripts"
  src_dir="$DOTFILES_ROOT/bin"
  dst_dir="$HOME/bin"

  info "mkdir -p $dst_dir"
  mkdir -p "$dst_dir"

  info "Create symlinks and RUN chmod +x for all scripts in $dst_dir to make them executable."

  for file in $(ls "$src_dir"); do
    src="$src_dir/$file"
    dst="$dst_dir/$file"
    link_file "$src" "$dst"
    chmod +x "$dst"
  done

}

install_awesome_vim() {
  local overwrite_all=false backup_all=false skip_all=false

  info "installing awesome vim"
  dst="$HOME/.vim_runtime"
  if [ ! -d "$dst" ]; then
    git clone --depth=1 https://github.com/amix/vimrc.git $dst
  fi
  link_file "$DOTFILES_ROOT/vim/my_configs.vim" "$HOME/.vim_runtime/my_configs.vim"
  sh "$HOME/.vim_runtime/install_awesome_vimrc.sh"
}

# TODO: include extension installation from list of extensions in vscode/code_extensions
# method: sort extension file, list current extensions with code --list-extensions and install missing extensions with code --install-extension ext
configure_vscode_settings() {
  if [[ $OSTYPE == "darwin"* ]]; then
    if type code &>/dev/null; then
      src="$DOTFILES_ROOT/vscode/settings.json.symlink"
      dst="$HOME/Library/Application Support/Code/User/settings.json"
      link_file "$src" "$dst"

    else
      echo "Symlinking VSCode requires Code to be installed (use brew)."
    fi
  else
    echo "Symlinking VSCode settings is only implemented for MacOS."
  fi
}

setup_gitconfig
install_dotfiles
install_user_bin
install_awesome_vim
configure_vscode_settings

# TODO: I include something like this
# function usage() {
# 	cat <<EOF
# usage: $0 [options]

# Set up a fresh Mac or run individual parts of it.

# OPTIONS:
#   --help|-h       Show this message
#   --update|-u     Install macOS updates
#   --brew|-b       Install Homebrew, all brew.txt packages an cask-minimal.txt
#   --full|-f       Install all brew packages and casks defined in cask-full.txt
#   --dotfiles|-d   Install dotfiles repo or update it
#   --defaults|-D   Install default user settings
# Without any option it runs the complete setup.
# EOF
# 	exit 1
# }

# # Main

# UPDATE=0
# BREW=0
# FULL=0
# DOTFILES=0
# DEFAULTS=0
# # translate long options to short
# for arg; do
# 	delim=""
# 	case "${arg}" in
# 	--help) args="${args}-h " ;;
# 	--update) args="${args}-u " ;;
# 	--brew) args="${args}-b " ;;
# 	--full) args="${args}-f " ;;
# 	--dotfiles) args="${args}-d " ;;
# 	--defaults) args="${args}-D " ;;
# 	# pass through anything else
# 	*)
# 		[[ "${arg:0:1}" == "-" ]] || delim="\""
# 		args="${args}${delim}${arg}${delim} "
# 		;;
# 	esac
# done
# # reset the translated args
# eval set -- "$args"
# # now we can process with getopt
# while getopts ":ubfdDt" opt; do
# 	case $opt in
# 	h) usage ;;
# 	u) UPDATE=1 ;;
# 	b) BREW=1 ;;
# 	f) FULL=1 ;;
# 	d) DOTFILES=1 ;;
# 	D) DEFAULTS=1 ;;
# 	\?) usage ;;
# 	:)
# 		echo "option -$OPTARG requires an argument"
# 		usage
# 		;;
# 	esac
# done
# shift $((OPTIND - 1))

# if [ -z "$args" ]; then
# 	UPDATE=1
# 	BREW=1
# 	FULL=1
# 	DOTFILES=1
# 	DEFAULTS=1
# fi

# if [ $UPDATE == 1 ]; then check_macos_updated; fi
# if [ $BREW == 1 ]; then install_brew; fi
# if [ $BREW == 1 ]; then install_brew_packages minimal; fi
# if [ $DOTFILES == 1 ]; then install_dotfiles; fi
# if [ $DEFAULTS == 1 ]; then set_defaults; fi
# if [ $FULL == 1 ]; then install_brew_packages full; fi
