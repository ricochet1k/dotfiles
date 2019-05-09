#!/bin/sh

cd $(dirname "$0")

[ -d external ] || mkdir -p external
[ -d external/kakoune ] || (
  cd external
  git clone https://github.com/mawww/kakoune
)

./opt/bin/update_kakoune.sh

if ! type rustup ; then
  curl https://sh.rustup.rs -sSf | sh
  source ~/.cargo/env
fi

type fd || cargo install fd-find
type exa || cargo install exa
type rg || cargo install ripgrep
type sk || cargo install skim
type sd || cargo install sd
type bat || cargo install bat
type watchexec || cargo install watchexec
type cargo-add || cargo install cargo-edit
type broot || cargo install --git https://github.com/Canop/broot

