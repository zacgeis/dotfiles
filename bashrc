export PATH=$HOME/bin:/usr/local/bin:/usr/local/share/python:$HOME/.rvm/bin:$PATH
export JAVA_HOME=/Library/Java/Home
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export EDITOR='vim'
export NODE_PATH=/usr/local/lib/node:$NODE_PATH

alias grep='grep --color=auto'
alias ls='ls'
alias rc='rake_commit'
alias ll='ls -la'

# fs filename filename_filter
f() {
  find . -name "*$1*$2"
}

# fs text filename_filter
fs() {
  find . -name "*$2*" -type f -exec grep -i --color=auto "$1" /dev/null '{}' \+
}

# fsr text replacement filename_filter
fsr() {
  fs $1 $3 | awk -F':' '{print $1}' | xargs -o -L 1 vim -c "%s/$1/$2/gc" -c "wq"
}

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1='\[\033[01;32m\]\u@\h:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;32m\]$(parse_git_branch)\[\033[00m\] $ '

if [ -f ~/code/personal/ec2/env ]; then
  source ~/code/personal/ec2/env
fi

if [ -f ~/bt/system-scripts/pairing_stations/ec2env ]; then
  export SYSTEM_SCRIPTS=~/bt/system-scripts
  source ~/bt/system-scripts/pairing_stations/ec2env
fi

if [ -f ~/bt/system-scripts/pairing_stations/aliases ]; then
  source ~/bt/system-scripts/pairing_stations/aliases
fi

if [ which brew &> /dev/null ]; then
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    source `brew --prefix`/etc/bash_completion
  fi

  if [ -f `brew --prefix git`/etc/bash_completion.d/git-completion.bash ]; then
    source `brew --prefix git`/etc/bash_completion.d/git-completion.bash
  fi
fi

if [[ -s ~/.rvm/scripts/rvm ]]; then
  source ~/.rvm/scripts/rvm
fi

[[ -r $rvm_path/scripts/completion ]] && source $rvm_path/scripts/completion

export LANG=en_US.UTF-8

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval "$(rbenv init -)"
