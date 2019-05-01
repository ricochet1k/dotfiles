#!/bin/sh

HERE=$(realpath $(dirname $0))
DOTFILES=$HERE/../..

cd $DOTFILES/external/kakoune
git pull
cd src
env PREFIX=$DOTFILES/opt make debug=no -j$(nproc)
rm -r $DOTFILES/opt/share/kak
env PREFIX=$DOTFILES/opt make debug=no -j$(nproc) install

if [ -n "$XDG_CONFIG_HOME" ]; then
  KAK_CONFIG="$XDG_CONFIG_HOME/kak"
else
  KAK_CONFIG="$HOME/.config/kak"
fi

echo "KAK_CONFIG: $KAK_CONFIG"

if [ -d $KAK_CONFIG/ ]; then
  rm -r $KAK_CONFIG/autoload
  ln -s $DOTFILES/kakoune/autoload $KAK_CONFIG/autoload
fi

