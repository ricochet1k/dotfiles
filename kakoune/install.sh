#!/bin/sh

mkdir -p ~/.config/kak/

echo "source $( cd `dirname $0`; pwd -P )/kakrc.kak" >> ~/.config/kak/kakrc

