#!/bin/sh

HERE=$(realpath $(dirname $0))
OPT=$HERE/..

cd $OPT/../external/kakoune
git pull
cd src
env PREFIX=$OPT make debug=no -j$(nproc) install

