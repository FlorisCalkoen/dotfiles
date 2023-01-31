#!/bin/bash

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)
echo "Using $DOTFILES_ROOT as DOTFILES_ROOT"
set -e

SRC="$HOME/.jupyter/lab/user-settings/"
DST="$DOTFILES_ROOT/jupyter/lab/user-settings/"

if [[ -d "$SRC" ]];then
    rsync -a "$SRC" "$DST" --delete
    echo "sync $SRC with $DST"
else
    echo "Cannot find user settings, $SRC does not exist."
fi

SRC="$HOME/.jupyter/jupyter_config.json"
DST="$DOTFILES_ROOT/jupyter/jupyter_config.json"

if [[ -f "$SRC" ]];then
    rsync -a "$SRC" "$DST" --delete
    echo "sync $SRC with $DST"
else
    echo "Cannot find user settings, $SRC does not exist."
fi
