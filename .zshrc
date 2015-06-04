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


if [[ -d "$ADMIN_SCRIPTS" ]]; then
  alias gt='parsebox go test'
  source "$ADMIN_SCRIPTS/master.zshrc"
fi

export GOPATH="$HOME/hungry/go"

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
)
for i in $paths; do
  export PATH="$PATH:$i"
done

command -v go > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
  export GOROOT=`go env GOROOT`
fi
export PATH="$PATH:$GOROOT/bin"
if [[ -d "$ADMIN_SCRIPTS" ]]; then

  paths=(
    /home/engshare/admin/scripts
    /home/engshare/admin/scripts/git
    /home/engshare/admin/scripts/hg
  )

  for i in $paths; do
    export PATH="$PATH:$i"
  done
  source "${ADMIN_SCRIPTS}/scm-prompt"
  export HTTP_PROXY=http://fwdproxy.any.facebook.com:8080
  export HTTPS_PROXY=http://fwdproxy.any.facebook.com:8080
  export NO_PROXY=fbcdn.net,facebook.com,thefacebook.com,tfbnw.net,fb.com,fburl.com,localhost
  export VIRTUAL_ENV_DISABLE_PROMPT=1
  source "/home/abhishekk/pyvirtualenv/BASE/bin/activate"
fi

eval "$(rbenv init -)"
export LANG=en_US.UTF-8
# added by travis gem
[ -f /Users/abhishekk/.travis/travis.sh ] && source /Users/abhishekk/.travis/travis.sh
# fasd stuff
eval "$(fasd --init auto)"

# The next line updates PATH for the Google Cloud SDK.
GOOGLE_APPENGINE_SDK="$HOME/google-cloud-sdk/path.zsh.inc"
[ -f "$GOOGLE_APPENGINE_SDK" ] && source "$GOOGLE_APPENGINE_SDK"


if [[ -d "/Users/abhishekk/.boot2docker" ]]; then
# docker mac stuff
  export DOCKER_HOST=tcp://192.168.59.103:2376
  export DOCKER_CERT_PATH=/Users/abhishekk/.boot2docker/certs/boot2docker-vm
  export DOCKER_TLS_VERIFY=1
fi

#add custom arcanist install path
ARC_BIN_PATH="$HOME/arcanist/arcanist/bin"
if [[ -d $ARC_BIN_PATH ]]; then
  export PATH="$PATH:$ARC_BIN_PATH"
fi

# Get a random quote fron the site http://www.quotationspage.com/random.php3
# Created by Eduardo San Martin Morote aka Posva
# http://posva.github.io
# Sun Jun 09 10:59:36 CEST 2013 
# Don't remove this header, thank you
# Usage: quote

WHO_COLOR="\e[0;33m"
TEXT_COLOR="\e[0;35m"
COLON_COLOR="\e[0;35m"
END_COLOR="\e[m"

if [[ -x `which curl` ]]; then
    function quote()
    {
        Q=$(curl -s --connect-timeout 2 "http://www.quotationspage.com/random.php3" | iconv -c -f ISO-8859-1 -t UTF-8 | grep -m 1 "dt ")
        TXT=$(echo "$Q" | sed -e 's/<\/dt>.*//g' -e 's/.*html//g' -e 's/^[^a-zA-Z]*//' -e 's/<\/a..*$//g')
        W=$(echo "$Q" | sed -e 's/.*\/quotes\///g' -e 's/<.*//g' -e 's/.*">//g')
        if [ "$W" -a "$TXT" ]; then
          echo "${WHO_COLOR}${W}${COLON_COLOR}: ${TEXT_COLOR}“${TXT}”${END_COLOR}"
        else
          quote
        fi
    }
    quote
else
    echo "rand-quote plugin needs curl to work" >&2
fi

# All the aliases
alias nproc='sysctl -n hw.ncpu'
alias ag='ag --color-match 31\;31 --color-line-number 2\;33 --color-path 2\;32'
alias agg='ag --go'
alias gt='go test -cpu=2 -parallel=10'
alias v='f -e vim' # quick opening files with vim
alias agr="ag --ruby"
alias goapp="$HOME/google-cloud-sdk/platform/google_appengine/goapp"
if ! type "hub" > /dev/null; then
  eval "$(hub alias -s)" #alias hub ?
fi
