
export ZSH=/Users/sheki/.oh-my-zsh
ZSH_THEME="random"
plugins=(git fasd vim)
source $ZSH/oh-my-zsh.sh


export EDITOR="vim"
export ADMIN_SCRIPTS="/home/engshare/admin/scripts"

# prefer gnu coreutils
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
alias ls='ls --color=tty'

export GOPATH="$HOME/go"
VIRTUAL_ENV_DISABLE_PROMPT=1 source $HOME/.virtualenv/VIRTUAL/bin/activate

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
# added by travis gem
[ -f /Users/abhishekk/.travis/travis.sh ] && source /Users/abhishekk/.travis/travis.sh

# The next line updates PATH for the Google Cloud SDK.
GOOGLE_APPENGINE_SDK="$HOME/google-cloud-sdk/path.zsh.inc"
[ -f "$GOOGLE_APPENGINE_SDK" ] && source "$GOOGLE_APPENGINE_SDK"


#add custom arcanist install path
ARC_BIN_PATH="$HOME/arcanist/arcanist/bin"
if [[ -d $ARC_BIN_PATH ]]; then
  export PATH="$PATH:$ARC_BIN_PATH"
fi


NPM_HOME=$(npm config get prefix)
PATH="$PATH:$NPM_HOME/bin"

# All the aliases
alias nproc='sysctl -n hw.ncpu'
alias ag='ag --color-match 31\;31 --color-line-number 2\;33 --color-path 2\;32'
alias v='f -e vim' # quick opening files with vim
