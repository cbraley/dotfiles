# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#The variable unamestr is used to identify the current OS throughout my bashrc
unamestr=`uname`

# Source EC2 config before anything else if this machine has it.
if [ -f /Users/cbraley/Projects/EC2/ec2_setup.sh ]; then
    source /Users/cbraley/Projects/EC2/ec2_setup.sh
fi

# Aliases for new commands.

# Make a short alias for the pip Python package manager when using MacPorts.
if [ -f /opt/local/bin/pip-2.7 ]; then
    alias pip='sudo /opt/local/bin/pip-2.7 '
fi

# Always use colorized ls output.
alias ls='ls -G'

# The "explore" command opens up a file browser in the current directory.
if [[ "$unamestr" == 'Darwin' ]]; then
  # On MacOS use "open"
  alias explore='open "`pwd`"'

  # OS X defaults to BSD sed.  We need gnu sed for some of my bash
  # completion scrips and other things to work.
  alias sed='gsed'
elif [[ "$unamestr" == 'Linux' ]]; then
  # On Linux, use the nautilus file browser I like.
  alias explore='nautilus -n `pwd` 2> /dev/null'
elif [[ "$unamestr" == 'MINGW32_NT' ]]; then
  # On windows, open windows explorer
  # TODO(cbraley): Note that this is untested!
  alias explore='explorer .'
fi

# Make sure opt/local/bin is on the PATH when on Mac OS
# Some MacOS programs mess with PATH ...
if [[ "$unamestr" == 'Darwin' ]]; then
  if [[ ":$PATH:" != *":$H/opt/local/bin:"* ]]; then
    # Fixup path
    export PATH="/opt/local/bin:$PATH"
  fi
fi

# Add tools from ~/tools to PATH
if [[ ":$PATH:" != *":$H~/tools:"* ]]; then
  export PATH="~/tools:$PATH"
fi

# Let's use vim for tools that respond to $EDITOR.
export EDITOR='vim'

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
if [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi
if [ -f /opt/local/etc/bash_completion ]; then
  . /opt/local/etc/bash_completion
fi
if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    . /opt/local/etc/profile.d/bash_completion.sh
fi

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

BgDarkGray="\[\e[100m\]"
BgGreen="\[\e[42m\]"
BgYellow="\[\e[43m\]"
BgBlue="\[\e[44m\]"
BgLightGray="\[\e[47m\]"

#     Reset bash color style.
RS="\[\033[0m\]"    # reset

# Setup a pretty+informative bash prompt.
# PS1 = The "normal" prompt when typing a new command.
# PS2 = The secondary prompt when a command needs more input.

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

PROMPT_DIRTRIM=3
PS1="$Green$BgDarkGray\D{%m/%d %R}$RS$IWhite|$RS$Blue\j$IWhite|$RS$IGreen\w$RS$IWhite($RS$Blue\$(parse_git_branch)$RS$IWhite)$RS$IRed\$$RS"
PS2="$Green$BgDarkGray...>$RS$IRed\$$RS "

# -----------------------------------------------------------------------------
# Boilerplate not added by me -------------------------------------------------
# -----------------------------------------------------------------------------

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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

# Enable color support of ls and also add handy aliases
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

slowcommand(){
    start=$(date +%s)
    "$@"
    [ $(($(date +%s) - start)) -le 15 ] || notify-send "Notification" "Long\
 running command \"$(echo $@)\" took $(($(date +%s) - start)) seconds to finish"
}

# If we are running this on a google machine, source some google-only magic
# bash functions.
if [ -f ~/.google_internal_bashrc ]; then
    source ~/.google_internal_bashrc
fi
