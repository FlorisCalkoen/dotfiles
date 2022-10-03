#!/usr/bin/env bash

DOTFILES_ROOT=$HOME/.dotfiles
OBSVAULT_SRC=$DOTFILES_ROOT/obsidian
OBSVAULT_DST=$HOME/obsvault
echo "$DOTFILES_ROOT"


set_src(){
    src="$OBSVAULT_SRC/$LINKFILE"
}

set_dst(){
    dst="$OBSVAULT_DST/$LINKFILE"
}

LINKFILE=".obsidian/snippets/callouts.css"
set_src
set_dst
ln -s "$src" "$dst"
echo "symlinking $src to $dst"

LINKFILE="meta/zotero"
set_src
set_dst
ln -s "$src" "$dst"
echo "symlinking $src to $dst"
