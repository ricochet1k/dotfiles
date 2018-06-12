#!/bin/sh

cd $(dirname "$0")

mkdir -p external
if [ ! -e bork ] ; then
  (cd external; git clone https://github.com/mattly/bork)
fi

