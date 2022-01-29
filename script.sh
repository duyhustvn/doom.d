#!/bin/sh

echo "COPY .extension for debug to .emacs.d starting"
cp -R .extension ~/.emacs.d/
echo "COPY .extension for debug to .emacs.d done"


echo "Install package libtool-bin (requirement for vterm) starting"
sudo apt install libtool-bin
echo "Install package libtool-bin (requirement for vterm) done"

pip3 install --user pytest
pip3 install --user debugpy
