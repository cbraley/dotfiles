#The variable unamestr is used to identify the current OS throughout my bashrc
unamestr=`uname`

# Aliases for new commands.

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

export PATH="${PATH}:/usr/local/google/home/cbraley/Projects/android_studio/android-studio/bin/"
export ANDROID_NDK=/usr/local/google/home/cbraley/Projects/android_ndk/android-ndk-r10e/
export MARVELL_AMP=/usr/local/google/home/cbraley/Projects/marvell_amp/prebuilts/bg2q4k_tpv2k15/amp
#export ANDROID_HOME=/usr/local/google/home/cbraley/Projects/android_studio/android-studio/
export ANDROID_HOME=/usr/local/google/home/cbraley/Projects/android_sdk/android-sdk-linux

# Fileutil bash completion.
# https://sites.google.com/a/google.com/gqui/advanced-usage#TOC-Use-gqui-s-tab-completion-with-fileutil
complete -o nospace -C 'G_COMP_WORDBREAKS="${COMP_WORDBREAKS}" \
GQUI_CLI_FILEUTIL_MODE=1 GQUI_CLI_SOCKET=~/.gqui/fileutil-tab \
/usr/bin/cli-client-gqui COMPLETE' fileutil


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

# Now, source bash-completion code I downloaded.  This handles many
# commmon file types.
#if [ -f `pwd`/bash_completion_2.1/bash_completion ]; then
#  source `pwd`/bash_completion_2.1/bash_completion
#fi

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
  #git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}


PROMPT_DIRTRIM=3
PS1="$Green$BgDarkGray\D{%m/%d %R}$RS$IWhite|$RS$Blue\j$IWhite|$RS$IGreen\w$RS$IWhite($RS$Blue\$(parse_git_branch)$RS$IWhite)$RS$IRed\$$RS"
#PS1="$Yellow\u$RS@$Green\$(~/tools/short_prompt_pwd.py)$RS:[$Red\$(parse_git_branch)$RS]$Cyan\$$RS"
PS2="$Green$BgDarkGray...>$RS$IRed\$$RS "

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


# Matlab license servers.  I found this in a matlab-users thread after a problem
# happened and I needed to update stuff.
export LM_LICENSE_FILE=26000@license-matlab4.corp.google.com,26000@license-matlab5.corp.google.com,26000@license-matlab6.corp.google.com

# Helpful flags that I nearly always pass to C++ binaries that I am running
# locally.
export CPP_BIN_FLAGS=' --alsologtostderr  --util_status_save_stack_trace  --suppress_failure_output  --rpclog=-1'


export BLAZE_LOCAL_TEST='blaze test --test_arg=--util_status_save_stack_trace --test_arg=--suppress_failure_output  --test_arg=--alsologtostderr  --test_output=streamed   -c opt '

# My x20 www dir.
export MY_X20=/google/data/rw/users/cb/cbraley/www/

export RAILS_CONTROL_MACHINE=rls1-wall-ctrl.mtv

# Chauffeur
alias tap_sync="/google/data/ro/projects/testing/tap/scripts/tap_sync"


export LOCAL_DIR=/usr/local/google/chauffeurdata


alias fu='fileutil -l -lh -F -sharded --parallel_copy=40 --parallel_rm=40 --parallel_chgrp=40 --parallel_chown=40 --colossus_parallel_copy'

export CAR_SCRIPTS=/home/build/nonconf/google3/third_party/car/scripts/

alias run_playback='/home/build/nonconf/google3/third_party/car/scripts/run_playback.sh'

alias iblaze=/google/data/ro/teams/iblaze/iblaze

export CAR_BINS_DIR=/google/data/ro/projects/chauffeur/


alias start_new_perception_git5_client='git5 start clean && git5 track third_party/car/perception/sensor_validation third_party/car/onboard/perception/sensor_validation third_party/car/scripts  third_party/car/simulator/testing third_party/car/onboard/messages/proto  experimental/users/cbraley/car third_party/car/simulator/scenario_tests third_party/car/param experimental/users/cbraley/scripts/'


alias glinkchecker='/google/data/ro/teams/linkchecker/linkchecker'


slowcommand(){
    start=$(date +%s)
    "$@"
    [ $(($(date +%s) - start)) -le 15 ] || notify-send "Notification" "Long\
 running command \"$(echo $@)\" took $(($(date +%s) - start)) seconds to finish"
}


alias @dbg=/google/data/ro/teams/ads-test-debugger/@dbg


alias slowblaze="slowcommand blaze"

alias pynotebook="jupyter notebook"

alias car_tap_submit="tap_presubmit -s -p chauffeur -c CL "

BRIDGE_ARGS="--log_extensions="gbr,pbr,velo,grass,tbr,radar,.grasshopper.camj.clf,.v4l2camerafront.camj.clf,.cam_fl.camj.clf,.cam_fr.camj.clf,.cam_rear.camj.clf" --param_file= /google/data/ro/projects/chauffeur/param/build2-surface-streets.in2 --block_on_log_extensions"

alias LAUNCH_XVIEW="/google/data/ro/projects/chauffeur/x_view --config ~/.xviewconfig"
alias LAUNCH_FRESHBINS_XVIEW="/google/data/ro/projects/chauffeur/freshbins/latest/x_view --config ~/.xviewconfig"


export FRESHBINS_DIR=/google/data/ro/projects/chauffeur/freshbins/latest

alias bm=/google/data/ro/users/re/reinerp/tools/bm


export SENSOR_VAL_FLAGS='--sensor_validation_gls=true --sensor_validation_time_series_plots=true --alsologtostderr'

