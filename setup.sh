#!/bin/sh

cd $(dirname "$0")

[ -d external ] || mkdir -p external
[ -d external/bork ] || (cd external; git clone https://github.com/mattly/bork)

type rustup || curl https://sh.rustup.rs -sSf | sh

type fd || cargo install fd-find
type exa || cargo install exa
type rg || cargo install ripgrep

type kak-lsp || cargo install --force --git https://github.com/ul/kak-lsp

