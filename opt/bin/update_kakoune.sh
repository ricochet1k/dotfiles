#!/bin/sh

HERE=$(dirname $0)
OPT=$HERE/..

cd $OPT/../kakoune
git pull
cd src
env PREFIX=$OPT make debug=no -j4 install

