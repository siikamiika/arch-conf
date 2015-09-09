#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias tl='/home/siikamiika/koodi/gt/gt_console -tT'
alias gt_play='gt_play -p mpg123'
PS1='[\u@\h \W]\$ '
export EDITOR=vim
