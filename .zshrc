export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="muse"
DISABLE_AUTO_TITLE="true"
plugins=(git fasd vim)
source $ZSH/oh-my-zsh.sh

export EDITOR="vim"

# prefer gnu coreutils
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
export MANPATH="/usr/local/man:$MANPATH"

alias ls='ls --color=tty'

export GOPATH="$HOME/go"
# VIRTUAL_ENV_DISABLE_PROMPT=1 source $HOME/.virtualenv/VIRTUAL/bin/activate

paths=(
  $HOME/.rbenv/bin
  /usr/local/bin
  /usr/local/go/bin
  /usr/local/sbin
  /usr/X11/bin
  /opt/local/bin
  /opt/local/sbin
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  $GOPATH/bin
  $HOME/bin
  $HOME/software/bazel/output
  /usr/local/dev-env/bin
  $HOME/.virtualenv/VIRTUAL/bin
)
for i in $paths; do
  export PATH="$PATH:$i"
done

command -v go > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
  export GOROOT=`go env GOROOT`
fi
export PATH="$PATH:$GOROOT/bin"

command -v fasd> /dev/null 2>&1
if [[ $? -eq 0 ]]; then
  eval "$(fasd --init auto)"
fi

export LANG=en_US.UTF-8
# The next line updates PATH for the Google Cloud SDK.
GOOGLE_APPENGINE_SDK="$HOME/google-cloud-sdk/path.zsh.inc"
[ -f "$GOOGLE_APPENGINE_SDK" ] && source "$GOOGLE_APPENGINE_SDK"

NPM_HOME=$(npm config get prefix)
PATH="$PATH:$NPM_HOME/bin"

# All the aliases
alias nproc='sysctl -n hw.ncpu'
alias ag='ag --color-match 31\;31 --color-line-number 2\;33 --color-path 2\;32'
alias v='f -e vim' # quick opening files with vim

# added by travis gem
[ -f /Users/sheki/.travis/travis.sh ] && source /Users/sheki/.travis/travis.sh

eval `dircolors ~/.dir_colors`
# EMOJI PROMPT HACK
EMOJI=(💩 🐦 🚀 🐞 🎨 🍕 🐭 👽 ☕️ 🔬 💀 🐷 🐼 🐶 🐸 🐧 🐳 🍔 🍣 🍻 🔮 💰 💎 💾 💜 🍪 🌞 🌍 🐌 🐓 🍄 )

function random_emoji {
  echo -n "$EMOJI[$RANDOM%$#EMOJI+1]"
}
PROMPT="$(random_emoji) $PROMPT"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export PASSWORD_STORE_DIR="$HOME/Dropbox/spm"
export PASSWORD_STORE_KEY="D8F115F8"
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"


### RBENV JUNK
export PATH="$HOME/.rbenv/shims:${PATH}"
export RBENV_SHELL=zsh
source '/usr/local/Cellar/rbenv/1.1.0/libexec/../completions/rbenv.zsh'
command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}

export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"
export PKG_CONFIG_PATH="/opt/local/lib/pkgconfig:$PKG_CONFIG_PATH"

export PATH=/opt/pkgconfig/bin:$PATH
export PKG_CONFIG_PATH="/opt/local/lib/pkgconfig:$PKG_CONFIG_PATH"

fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# place this after nvm initialization!
# autoload -U add-zsh-hook
# load-nvmrc() {
#   local node_version="$(nvm version)"
#   local nvmrc_path="$(nvm_find_nvmrc)"
#
#   if [ -n "$nvmrc_path" ]; then
#     local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
#
#     if [ "$nvmrc_node_version" = "N/A" ]; then
#       nvm install
#     elif [ "$nvmrc_node_version" != "$node_version" ]; then
#       nvm use
#     fi
#   elif [ "$node_version" != "$(nvm version default)" ]; then
#     echo "Reverting to nvm default version"
#     nvm use default
#   fi
# }
# add-zsh-hook chpwd load-nvmrc
# load-nvmrc
PLAN9=$HOME/plan9port
PATH=$PATH:$PLAN9/bin

fbr() {
  local branches branch
  branches=$(git branch -vv) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

fadd() {
  local branches branch
  branches=$(git ls-files|sort|uniq) &&
    branch=$(echo "$branches" | fzf +m) &&
    echo "$branch" | awk '{print $1}' | sed "s/.* //"
}


export PATH="$HOME/.yarn/bin:$PATH"
alias tmux="TERM=screen-256color tmux"
HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups

fzf-git-ls-files() {
  if [[ -f '.git/config' ]]; then

    
    cmd=$(git status --porcelain |rev|cut -d" " -f1 |rev)
    foo="$(echo $cmd| fzf +s +m -n2..,..)"
  else
    echo "Not a git repo\n"
  fi

  zle -U $foo
}

zle     -N   fzf-git-ls-files
bindkey '^o' fzf-git-ls-files
ssh-add -A &> /dev/null
