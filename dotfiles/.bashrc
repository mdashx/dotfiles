# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# nohup bash /home/tom/dotfiles/sync-clock.sh &>/dev/null &

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi




# My Stuff
PS1="\u@\h \W$ "
LS_COLORS=$LS_COLORS:'ow=01;34:' ; export LS_COLORS

export EDITOR=emacs
alias emacs='emacsclient-snapshot -t'
# Need alias for emacs (emacs-snaptho --daemon, emacsclient-snapshot -t)

# export GOPATH=$HOME/go
# export GOPATH=$GOPATH:$ANALYST_PORTAL_DIR/go

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/bin
# export PATH=$PATH:$HOME/go/bin

export WINHOME=/mnt/c/Users/johng/shared
alias home="cd $WINHOME"

export PATH=$HOME/.npm-global/bin:$PATH
export PATH=$WINHOME/.npm-global/bin:$PATH

# export WORKON_HOME=/mnt/c/Users/Tom/.virtualenvs
export WORKON_HOME=/home/tom/.virtualenvs

# source /usr/local/bin/virtualenvwrapper.sh

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

# export PATH="/home/vagrant/.pyenv/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"


function get_pilot_bastion_ip {
    aws ec2 describe-instances --filters "Name=tag:aws:cloudformation:stack-name,Values=pilot-bastion" --query 'Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].PrivateIpAddress' --output text
}

function get_production_bastion_ip {
    aws ec2 describe-instances --filters "Name=tag:aws:cloudformation:stack-name,Values=production-bastion" --query 'Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].PrivateIpAddress' --output text
}

function get_utility_bastion_ip {
    aws ec2 describe-instances --filters "Name=tag:aws:cloudformation:stack-name,Values=utility-bastion" --query 'Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].PrivateIpAddress' --output text
}

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export N_PREFIX=/home/tom/usr/local
export PATH="/home/tom/usr/local/bin:$PATH"

alias pyvenv="source .venv/bin/activate"

alias pycreate="python3 -m venv .venv/"

# TODO - would be better to use symlinks then copying the files XD

alias pyserver="python3 -m 'http.server'"
