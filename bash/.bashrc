# If not running interactively, don't do anything
[ -z "$PS1" ] && return

OS=$(uname)

if [ $OS == "Darwin" ]; then
  export EDITOR='code -w'
else
  export EDITOR=vim
fi

MITSUHIKOS_DEFAULT_COLOR="[00m"
MITSUHIKOS_GRAY_COLOR="[37m"
MITSUHIKOS_PINK_COLOR="[35m"
MITSUHIKOS_GREEN_COLOR="[32m"
MITSUHIKOS_ORANGE_COLOR="[33m"
MITSUHIKOS_RED_COLOR="[31m"
if [ `id -u` == '0' ]; then
  MITSUHIKOS_USER_COLOR=$MITSUHIKOS_RED_COLOR
else
  MITSUHIKOS_USER_COLOR=$MITSUHIKOS_PINK_COLOR
fi
MITSUHIKOS_VCPROMPT_EXECUTABLE=~/bin/vcprompt

mitsuhikos_vcprompt() {
  $MITSUHIKOS_VCPROMPT_EXECUTABLE -f $' on \033[34m%n\033[00m:\033[00m%[unknown]b\033[32m%m%u'
}

mitsuhikos_lastcommandfailed() {
  code=$?
  if [ $code != 0 ]; then
    echo -n $'\033[37m exited \033[31m'
    echo -n $code
    echo -n $'\033[37m'
  fi
}

mitsuhikos_backgroundjobs() {
  jobs|python -c 'if 1:
    import sys
    items = ["\033[36m%s\033[37m" % x.split()[2]
             for x in sys.stdin.read().splitlines()]
    if items:
      if len(items) > 2:
        string = "%s, and %s" % (", ".join(items[:-1]), items[-1])
      else:
        string = ", ".join(items)
      print("\033[37m running %s" % string)
  '
}

mitsuhikos_virtualenv() {
  if [ x$VIRTUAL_ENV != x ]; then
    echo -n $' \033[37mworkon \033[31m'
    basename "${VIRTUAL_ENV}"
    echo -n $'\033[00m'
  fi
}

export PRE_PS1=""
export MITSUHIKOS_BASEPROMPT='\n\e${MITSUHIKOS_ORANGE_COLOR}$PRE_PS1\e${MITSUHIKOS_USER_COLOR}\u \
\e${MITSUHIKOS_GRAY_COLOR}at \e${MITSUHIKOS_ORANGE_COLOR}\h \
\e${MITSUHIKOS_GRAY_COLOR}in \e${MITSUHIKOS_GREEN_COLOR}\w\
`mitsuhikos_lastcommandfailed`\
\e${MITSUHIKOS_GRAY_COLOR}`mitsuhikos_vcprompt`\
`mitsuhikos_backgroundjobs`\
`mitsuhikos_virtualenv`\
\e${MITSUHIKOS_DEFAULT_COLOR}'
export PS1="${MITSUHIKOS_BASEPROMPT}
$ "

export TERM=xterm-color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1

if [ `uname` == "Darwin" ]; then
  export LSCOLORS=ExGxFxDxCxHxHxCbCeEbEb
  export LC_CTYPE=en_US.utf-8
else
  alias ls='ls --color=auto'
fi

# alias git=hub
alias rvim="gvim --remote-silent"
shopt -s histappend

if [ -f /usr/local/git/contrib/completion ]; then
  . /usr/local/git/contrib/completion/git-completion.bash
fi
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# hack to get ppc out of that thing
export ARCHFLAGS="-arch i386 -arch x86_64"

# add some bins
export PATH=/usr/local/bin:/usr/local/sbin:~/bin:~/.bin:~/.bin/k8s:$PATH

# Virtualenvwrapper and pip settings
export WORKON_HOME=$HOME/.virtualenv
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
VIRTUAL_ENV_DISABLE_PROMPT=1

# Git autocompletion with HUB
if [ -f  /usr/local/git/contrib/completion/git-completion.bash ]; then
  source /usr/local/git/contrib/completion/git-completion.bash
fi

function runserver_auto() {
    if [ "$1" == "public" ]; then
        ip=`python -c "from urllib import urlopen; print urlopen('http://automation.whatismyip.com/n09230945.asp').read()"`
    else
	    ip=`python -c "import socket; print socket.gethostbyname(socket.gethostname())"`
    fi
    echo "Starting server on $ip"
    python manage.py runserver $ip:8000
}
alias runserver="runserver_auto"

# Git Flags - TODO: move to gitconfig
export GIT_DISCOVERY_ACROSS_FILESYSTEM=0
export GIT_SSL_NO_VERIFY=true
alias gitlog="git log --stat --color --pretty='%n%H %Cred %aN %Cblue %aD %n %Cgreen %s %Creset'"
alias gitdiff="git diff --color"
alias gitstat="git diff --color --stat"

# Node JS
if [ -d /usr/local/lib/node_modules ]; then
  export NODE_PATH="/usr/local/lib/node_modules"
fi

# Set default terminal to UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# Use bash-completion, if available
# cf. http://meinit.nl/bash-completion-mac-os-x
# cf. http://mult.ifario.us/p/getting-bash-completion-magic-on-os-x
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# Private bash settings
if [ -f $HOME/.bash_private ]; then
  . $HOME/.bash_private
fi

# bash decisio settings
if [ -f $HOME/.bash_decisio ]; then
  . $HOME/.bash_decisio
fi

# Source goto
[[ -s "/usr/local/Cellar/goto/2.0.0/etc/bash_completion.d/goto.sh" ]] && source /usr/local/Cellar/goto/2.0.0/etc/bash_completion.d/goto.sh

# Fubectl
[ -f "$HOME/.bin/fubectl.source" ] && source "$HOME/.bin/fubectl.source"

# Source docker-development envars
[[ -s "$HOME/Code/decisio/docker-development/.env_docker_development" ]] && source "$HOME/Code/decisio/docker-development/.env_docker_development"
