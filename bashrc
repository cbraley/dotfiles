# If not running interactively, don't do anything.
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

# The 'explore' command opens up a file browser in the current directory.
# The 'o' command opens the specified file with whatever application the OS
# chooses. For example, 'o foo.png' would open the image foo.png in an image
# viewer.
if [[ "$unamestr" == 'Darwin' ]]; then
  # On MacOS use "open"
  alias explore='open $(pwd)'
  alias o='open'

  # OS X defaults to BSD sed.  We need gnu sed for some of my bash
  # completion scrips and other things to work.
  #alias sed='gsed'
elif [[ "$unamestr" == 'Linux' ]]; then
  # On Linux, use the nautilus file browser I like.
  alias explore='xdg-open .'
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

# The command pretty_date produces a string like "1987_08_18".
alias pretty_date='date +"%Y_%m_%d"'

# Bash history configuration.

# Don't put duplicate lines or lines starting with space in the history
# (See bash(1) for more options).
export HISTCONTROL=ignoreboth

# Append to the history file; don't overwrite it.
shopt -s histappend

# Set history file size/length.
HISTSIZE=100001
HISTFILESIZE=200001

# https://unix.stackexchange.com/questions/131504/how-to-sync-terminal-session-command-history-in-bash
# export PROMPT_COMMAND="history -a; history -n"
# https://news.ycombinator.com/item?id=7982031
export PROMPT_COMMAND="history -a;history -c;history -r;$PROMPT_COMMAND"

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
#     High intensity.
IBlack="\[\033[0;90m\]"       # Black
IRed="\[\033[0;91m\]"         # Red
IGreen="\[\033[0;92m\]"       # Green
IYellow="\[\033[0;93m\]"      # Yellow
IBlue="\[\033[0;94m\]"        # Blue
IPurple="\[\033[0;95m\]"      # Purple
ICyan="\[\033[0;96m\]"        # Cyan
IWhite="\[\033[0;97m\]"       # White
#     Regular colors.
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

#function parse_git_dirty {
#  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
#}
#function parse_git_branch {
#  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
#}

# This function returns a string like "<CLIENT_NAME>@cl/<CL_NUMBER>" if in a
# piper client, or the empty string if not.
function synced_cl {
  # Check if the machine even has g4 installed. If not, exit early.
  which g4 > /dev/null
  if [ $? -ne 0 ]; then
    return
  fi

  # If we can't parse 'g4 client -o', then assume we aren't in a piper client.
  CLIENT_TXT=$(g4 client -o)
  CLIENT_FULL_PATH=$(echo "${CLIENT_TXT}" | grep -o Root:.* | grep -o '/.*$')
  CL_NUM=$(echo "${CLIENT_TXT}" | \
      grep -o  SyncChange.* | grep -o '[[:digit:]]\+')
  if [ $? -eq 0 ]; then
    CLIENT_NAME=$(basename ${CLIENT_FULL_PATH})
    printf "${CLIENT_NAME}"
    printf "@"
    printf "cl/${CL_NUM}"

  else
    printf ""
  fi
}

function last_exit_code {
  tmp_code=$?
  if [ $tmp_code -eq 0 ]; then
    echo ""
  else
    echo "${tmp_code}"
  fi
}

# Notes:
#   $\$(foo) evaluates 'foo' each time the prompt is redrawn, whereas
#   $(foo) evaluates 'foo' once when ~/.bashrc is run.\
#   Color codes have to be wrapped in \[ \] to make sure they are escaped
#   properly. If you don't do this, you will see weird re-draw errors when using
#   the up arrow.
PROMPT_DIRTRIM=3
SEP="|"
BRIGHT=$(tput bold)
GREEN="$(tput setaf 2)"
RED=$(tput setaf 1)
WHITE=$(tput setaf 7)
YELLOW="$(tput setaf 3)"

RESET=$(tput sgr0)

#PS1="\[${RED}\]\$(last_exit_code)\[${WHITE}\]${SEP}\[${GREEN}\]b\j\[${WHITE}\]${SEP}\[${GREEN}\]\w\[${WHITE}\]${SEP}\[${YELLOW}\]\[${BRIGHT}\]\$(parse_git_branch)\$(synced_cl)\[${RESET}\]\[${WHITE}\]►"
#PS2="\[${GREEN}\]...\[${RESET}\]\[${WHITE}\]►"

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}
PS1="\[\e[33m\]|\[\e[m\]\[\e[31m\]\$(last_exit_code)\[\e[m\]\[\e[33;40m\]|\[\e[m\]\[\e[32m\]\j\[\e[m\]\[\e[33m\]|\[\e[m\]\w\[\e[33m\]|\[\e[m\]\[\e[37m\]\`parse_git_branch\`\$(synced_cl)\[\e[m\]\[\e[36m\]\\$\[\e[m\] "
PS2="...$"

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

# We want screen to be able ot handle 256 colors.
TERM=xterm-256color

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

# bazel is installed to $HOME/bin
export PATH="$PATH:$HOME/bin"
# source bazel autocompletions.
if [ -f $HOME/.bazel/bin/bazel-complete.bash ]; then
  source $HOME/.bazel/bin/bazel-complete.bash
fi

# Append to history, don't overwrite it.
shopt -s histappend

# Don't store duplicate commands in bash history.
export HISTCONTROL=ignoredups

alias WEATHER_REPORT='curl http://wttr.in/'

# tmux related settings. -------------------------------------------------------

# https://unix.stackexchange.com/questions/1045/getting-256-colors-to-work-in-tmux
alias tmux='TERM=xterm-256color tmux '

# Use tmuxa to attach to a named tmux session.
alias tmuxls='TERM=xterm-256color tmux list-sessions '

# Use tmuxa to attach to a named tmux session.
alias tmuxa='TERM=xterm-256color tmux attach -t '

# Use tmuxad to attach to a named session while also detaching all other
# sessions. This will force nicer window resizing when changing monitor sizes.
alias tmuxad='TERM=xterm-256color tmux attach -d -t '

# Use tmux_new_session foo to start a new session named "foo".
alias tmux_new_session='TERM=xterm-256color tmux new -s '

# Use tmux_kill_session foo to delete a session named "foo".
# You can list all session names with 'tmux ls'.
alias tmux_kill_session='TERM=xterm-256color tmux kill-session -t '

# Disable "flow control" related stuff in tmux. Without this, pressing ctrl+s
# in tmux disabled flow control which causes the screen to stop redrawing.
# Ctrl+q can fix this, but it is still annoying. This magical incantation
# disables this "feature".
# https://unix.stackexchange.com/questions/12107/how-to-unfreeze-after-accidentally-pressing-ctrl-s-in-a-terminal
stty -ixon

# Image display related. -----------------------------------------------------

# Find an unused port. Since every tool at Google seems to contain 3 or more
# HTTP servers, this requires scanning.
function get_unused_port() {
  for port in $(seq 4444 65000);
  do
    echo -ne "\035" | telnet 127.0.0.1 $port > /dev/null 2>&1;
    [ $? -eq 1 ] && echo "$port" && break;
  done
}

# The imdisplay <X> function displays the image at path <X>. This function
# should work on the following setups:
#   * Ubuntu / Goobuntu desktops via xdg-open.
#   * MaxOS machines via the 'open' command.
#   * MacOS iterm2 via imgcat.sh ... shows images *in* the terminal...fancy!
#   * Any Linux variant where we can run python -m  SimpleHTTPServer.
#     This handles the case where you are working remotely via an SSSH
#     connection.
# Notable, we dont' support the following configurations:
#   * Anything with Windows cygwin.
#   * tmux sessions on a Mac.
#   * screen sessions.
function imdisplay() {
  echo "Displaying image \"$1\"..."

  # Use imgcat.sh if running directly in iTerm.
  if [[ "${TERM_PROGRAM}" == 'iTerm.app' ]]; then
    echo "Using iterm2 imgcat."
    ~/tools/imgcat.sh "$1"
    return 0
  fi

  # If on a Mac, use 'open'.
  if [[ "${unamestr}" == 'Darwin' ]]; then
    echo "MacOS without iterm2"
    open "$1"
    return 0
  fi

  # If on a Linux desktop with a display, run 'xdg-open'.
  if [ -z ${DISPLAY+x} ]; then
    echo "Linux desktop ${unamestr} with a display."
    xdg-open "$1"
    return 0
  fi

  # For all other machines (usually a Linux desktop over SSH), just launch
  # an HTTP server to serve the images. We print a URL the user can use to
  # browse to the images.
  echo "OS ${unamestr}"
  PORT="$(get_unused_port)"
  IMAGES_DIR=$(dirname $1)
  IMAGE_BASENAME=$(basename $1)
  pushd ${IMAGES_DIR}
  echo "http://${HOSTNAME}:${PORT}/${IMAGE_BASENAME}"
  echo "Press Ctrl-C when done viewing."
  python -m SimpleHTTPServer ${PORT}  > /dev/null 2>&1
  popd
  return 0
}


# If we are running this on a google machine, source some google-only magic
# bash functions and aliases.
if [ -f ~/.google_internal_bashrc ]; then
  source ~/.google_internal_bashrc
fi
