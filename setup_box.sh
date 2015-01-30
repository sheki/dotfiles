#!/bin/bash -e
ln -sf $(pwd)/.zshrc "$HOME/.vimrc"
vim -i NONE -c VundleClean -c quitall
vim -i NONE -c VundleUpdate -c quitall
ln -sf $(pwd)/.zshrc "$HOME/.zshrc"
