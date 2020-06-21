autoload -U compinit
compinit
autoload -U colors
colors

setopt no_auto_menu
setopt prompt_subst
setopt no_global_rcs

export PATH=$HOME/bin:/usr/local/bin:/usr/local/share/python:$HOME/.rvm/bin:$PATH
export JAVA_HOME=/Library/Java/Home
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export EDITOR='vim'
export NODE_PATH=/usr/local/lib/node:$NODE_PATH
export GOPATH=$HOME/go
export GPG_TTY=$(tty)

alias grep='grep --color=auto'
alias ls='ls'
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

# Legacy Bash Version
# parse_git_branch() {
#     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
# }
#
# PS1='\[\033[01;32m\]\u@\h:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;32m\]$(parse_git_branch)\[\033[00m\] $ '

git_prompt_info() {
  ref=$($(which git) symbolic-ref HEAD 2> /dev/null) || return
  user=$($(which git) config user.name 2> /dev/null)
  echo " (${user}@${ref#refs/heads/})"
}

export PROMPT='%{$fg_bold[green]%}%n@%m:%{$fg_bold[blue]%}%~%{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}%(!.#.$) '

export LANG=en_US.UTF-8

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
  [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
  eval "$("$BASE16_SHELL/profile_helper.sh")"

# first arg is number of ms till repeat, second arg is number of repeats within
# a second.
[ -x "$(command -v xset)" ] && xset r rate 190 50
