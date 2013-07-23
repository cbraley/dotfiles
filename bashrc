# Aliases for new commands.

# The "explore" command opens up a file browser in the current directory.
alias explore='nautilus -n `pwd` 2> /dev/null'


# Bash history configuration.

# Don't put duplicate lines or lines starting with space in the history
# (See bash(1) for more options).
HISTCONTROL=ignoreboth

# Append to the history file; don't overwrite it.
shopt -s histappend

# Set history file size/length.
HISTSIZE=100001
HISTFILESIZE=200001

# Allow extra bash completions if available.  /etc/bash_completion
#  First, source the systems bash completion stuff (if it exists).
if [ -f /etc/bash_completion ];
then
  source /etc/bash_completion
fi

# Now, source bash-completion code I downloaded.  This handles many
# commmon file types.
if [ -f `pwd`/bash_completion_2.1/bash_completion ];
then
  source `pwd`/bash_completion_2.1/bash_completion
fi

# Setup arrow-key based bash history search
#
# We want the up-arrow key to fetch previous commands that start with the
# currently typed prefix string aka "prefix based autocomplete from history."
# We create a file in the user's homedir, called ".inputrc" to do this.
# This code will create inputrc if it is not already there.  We also want to get
# menu-based TAB completion.

#if [ ! -f $HOME/.inputrc ];
#then
#    echo 'Creating $HOME/.inputrc...'
#    touch $HOME/.inputrc
#    echo -e '"\e[5~": history-search-backward \n' >> $HOME/.inputrc
#    echo -e '"\e[6~": history-search-forward  \n' >> $HOME/.inputrc
#    echo -e 'TAB: menu-complete \n'               >> $HOME/.inputrc
#fi
#export INPUTRC=$HOME/.inputrc

# Setup color aliases for more readable bash colorization(no escape seqs).
#     High Intensty.
IBlack="\[\033[0;90m\]"       # Black
IRed="\[\033[0;91m\]"         # Red
IGreen="\[\033[0;92m\]"       # Green
IYellow="\[\033[0;93m\]"      # Yellow
IBlue="\[\033[0;94m\]"        # Blue
IPurple="\[\033[0;95m\]"      # Purple
ICyan="\[\033[0;96m\]"        # Cyan
IWhite="\[\033[0;97m\]"       # White
#     Regular Colors.
Black="\[\033[0;30m\]"        # Black
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
Purple="\[\033[0;35m\]"       # Purple
Cyan="\[\033[0;36m\]"         # Cyan
White="\[\033[0;37m\]"        # White
#     Reset bash color style.
RS="\[\033[0m\]"    # reset

# Setup a pretty+informative bash prompt.
# PS1 = The "normal" prompt when typing a new command.
# PS2 = The secondary prompt when a command needs more input.
# TODO: Only do the \u@\h if this is not my default desktop...

# This one has no chomping...
#PS1="(\!):\u@\h:\w\$(git branch 2>/dev/null | grep -e '\* ' | sed 's/^..\(.*\)/($IRed\1$RS)/') $Yellow\$$RS"

# TODO: Implement a nicer chomp.
function __shortpath {
    if [[ ${#1} -gt $2 ]]; then
        len=$2+3
        echo "..."${1: -$len}
    else
        echo $1
    fi
}

# TODO: Figure out how to add \u@\h: (cbraley@some_machine) if
# we are on a non-default machine.
PS1="(\!):$(__shortpath "\w" 32)\$(git branch 2>/dev/null | grep -e '\* ' | sed 's/^..\(.*\)/($IRed\1$RS)/') $Yellow\$$RS"
PS2=".. \$"


# -----------------------------------------------------------------------------
# Boilerplate not added by me -------------------------------------------------
# -----------------------------------------------------------------------------

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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
