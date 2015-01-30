#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
export EDITOR="vim"
export ADMIN_SCRIPTS="/home/engshare/admin/scripts"

alias gt='go test -cpu=2 -parallel=10'

if [[ -z "$ADMIN_SCRIPTS" ]]; then
  alias gt='parsebox go test'
  source "$ADMIN_SCRIPTS/master.zshrc"
fi

export GOROOT=`go env GOROOT`
export GOPATH="$HOME/hungry/go"

path[1,0]=(
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
  $GOROOT/bin
  $GOPATH/bin
)
if [[ -z "$ADMIN_SCRIPTS" ]]; then

  path[1,0]=(
    /home/engshare/admin/scripts
    /home/engshare/admin/scripts/git
    /home/engshare/admin/scripts/hg
  )
  source "${ADMIN_SCRIPTS}/scm-prompt"
  export HTTP_PROXY=http://fwdproxy.any.facebook.com:8080
  export HTTPS_PROXY=http://fwdproxy.any.facebook.com:8080
  export NO_PROXY=fbcdn.net,facebook.com,thefacebook.com,tfbnw.net,fb.com,fburl.com,localhost
fi

eval "$(rbenv init -)"
alias agg='ag --go'
export LANG=en_US.UTF-8
alias ag='ag --color-match 31\;31 --color-line-number 2\;33 --color-path 2\;32'
alias agg="ag --go"
alias agr="ag --ruby"

# added by travis gem
[ -f /Users/abhishekk/.travis/travis.sh ] && source /Users/abhishekk/.travis/travis.sh
