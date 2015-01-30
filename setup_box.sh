#!/bin/bash -e
ln -sf $(pwd)/.vimrc "$HOME/.vimrc"
vim -i NONE -c VundleClean -c quitall
vim -i NONE -c VundleUpdate -c quitall

