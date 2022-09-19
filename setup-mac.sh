#!/usr/bin/env bash

set -e

DOTFILES_ROOT=$HOME/.dotfiles
echo "DOTFILES_ROOT: $DOTFILES_ROOT"

# Enforce that all updates are installed before we begin
function check_macos_updated() {
	echo "Checking if macOS is up to date..."
	if [[ "$(sudo softwareupdate -l 2>&1)" != *"No new software available"* ]]; then
		echo "Updating macOS"
		sudo softwareupdate -i -a
		echo "Reboot your machine now and run this script again afterwards."
		exit 0
	else
		echo "This macOS is up to date."
	fi
}

# Install brew and XCode Command Line Tools
function install_brew() {
	if ! command -v brew >/dev/null 2>&1; then
		echo "Installing Brew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		brew analytics off
	else
		echo "Brew already installed."
	fi
}

function install_dotfiles() {

	if [ ! -d $DOTFILES_ROOT ]; then
		echo "Cloning dotfiles repo to dotfiles root: $DOTFILES_ROOT"
		git clone https://github.com/FlorisCalkoen/dotfiles $DOTFILES_ROOT
	else
		echo "Updating dotfiles repo"
	fi
	cd $DOTFILES_ROOT
	./bootstrap.sh -f
}

function install_brew_packages() {
	mode=$1
	echo "Install new taps from brew.txt"
	comm -23 \
		<(sort $DOTFILES_ROOT/macos/brew.txt) \
		<(brew ls --full-name) |
		xargs brew install

	echo "Add new taps from brew-tap.txt"
	comm -23 \
		<(sort $DOTFILES_ROOT/macos/brew-tap.txt) \
		<(brew tap) |
		xargs brew tap

	echo "Install new casks from cask-$mode.txt"
	comm -23 \
		<(sort $DOTFILES_ROOT/macos/cask-$mode.txt) \
		<(brew list) |
		xargs brew install
}

function set_defaults() {
	echo "Setting user defaults stored in file: $DOTFILES_ROOT/macos/defaults"

	source $DOTFILES_ROOT/macos/defaults

}

function usage() {
	cat <<EOF
usage: $0 [options]

Set up a fresh Mac or run individual parts of it.

OPTIONS:
  --help|-h       Show this message
  --update|-u     Install macOS updates
  --brew|-b       Install Homebrew, all brew.txt packages an cask-minimal.txt
  --full|-f       Install all brew packages and casks defined in cask-full.txt
  --dotfiles|-d   Install dotfiles repo or update it
  --defaults|-D   Install default user settings
Without any option it runs the complete setup.
EOF
	exit 1
}

# Main

UPDATE=0
BREW=0
FULL=0
DOTFILES=0
DEFAULTS=0
# translate long options to short
for arg; do
	delim=""
	case "${arg}" in
	--help) args="${args}-h " ;;
	--update) args="${args}-u " ;;
	--brew) args="${args}-b " ;;
	--full) args="${args}-f " ;;
	--dotfiles) args="${args}-d " ;;
	--defaults) args="${args}-D " ;;
	# pass through anything else
	*)
		[[ "${arg:0:1}" == "-" ]] || delim="\""
		args="${args}${delim}${arg}${delim} "
		;;
	esac
done
# reset the translated args
eval set -- "$args"
# now we can process with getopt
while getopts ":ubfdDt" opt; do
	case $opt in
	h) usage ;;
	u) UPDATE=1 ;;
	b) BREW=1 ;;
	f) FULL=1 ;;
	d) DOTFILES=1 ;;
	D) DEFAULTS=1 ;;
	\?) usage ;;
	:)
		echo "option -$OPTARG requires an argument"
		usage
		;;
	esac
done
shift $((OPTIND - 1))

if [ -z "$args" ]; then
	UPDATE=1
	BREW=1
	FULL=1
	DOTFILES=1
	DEFAULTS=1
fi

if [ $UPDATE == 1 ]; then check_macos_updated; fi
if [ $BREW == 1 ]; then install_brew; fi
if [ $BREW == 1 ]; then install_brew_packages minimal; fi
if [ $DOTFILES == 1 ]; then install_dotfiles; fi
if [ $DEFAULTS == 1 ]; then set_defaults; fi
if [ $FULL == 1 ]; then install_brew_packages full; fi
