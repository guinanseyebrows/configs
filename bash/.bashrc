#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PATH=~/.local/bin:$PATH
#PS1='\[\033[01;33\][\w\] $\[\033[00m\]\ '
PS1='\[\033[01;37m\][\w]\[\033[00m\] $ '
