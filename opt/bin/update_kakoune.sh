#!/bin/sh

HERE=$(realpath $(dirname $0))
OPT=$HERE/..

cd $OPT/../external/kakoune
git pull
cd src
rm -r $OPT/share/kak
env PREFIX=$OPT make debug=no -j$(nproc) install

