#!/bin/bash -e
brew install vim git ag
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
ln -sf $(pwd)/.vimrc "$HOME/.vimrc"
vim -i NONE -c VundleClean -c quitall
vim -i NONE -c VundleUpdate -c quitall
ln -sf $(pwd)/.zshrc "$HOME/.zshrc"
