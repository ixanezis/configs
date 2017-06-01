# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE="" # unlimited bash history
HISTFILESIZE="" # unlimited bash history
export HISTTIMEFORMAT='%F %T '

# to correctly work with remote hosts
#export LC_ALL=en_US.UTF-8
#export LANG=en_US.UTF-8

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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

unset color_prompt force_color_prompt

tmux_pane() {
    hostname=$(hostname)
    hostname_prefix=${hostname%%.*}
    basename=$(basename $(pwd))
    printf "\033k$hostname_prefix:$basename\033\\"
}

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

mkdir -p "$HOME/.vim-undodir"

export LSCOLORS=Gxfxcxdxbxegedabagacad
if [ $(uname -s) = "Darwin" ]; then
    alias ls='gls --color=auto'
    eval $(gdircolors ~/dircolors-solarized/dircolors.256dark)
    source $(brew --prefix)/etc/bash_completion
fi

export GRADLE_OPTS=-Dorg.gradle.daemon=true

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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

python ~/colorize.py 0.7 0.44

set show-all-if-ambiguous on

GPG_INSTALLED=$(type gpg-agent 2>/dev/null && echo yes || echo no)
if [ "$GPG_INSTALLED" = "yes" ]; then
    GPG_RUNNING=true
    source "${HOME}/.gpg-agent-info" 2>/dev/null && GPG_AGENT_INFO=$GPG_AGENT_INFO gpg-connect-agent /bye 2>/dev/null || GPG_RUNNING=false
    [ $GPG_RUNNING = true ] || eval $(gpg-agent --daemon --write-env-file "${HOME}/.gpg-agent-info")
    export GPG_AGENT_INFO
    GPG_TTY=$(tty)
    export GPG_TTY
fi
mkdir -p ~/.vim/undodir

# Predictable SSH authentication socket location.
SOCK="$HOME/.ssh/ssh_auth_sock"
if [ "$SSH_AUTH_SOCK" ] && [ "$SOCK" != "$SSH_AUTH_SOCK" ]; then
    ln -sf "$SSH_AUTH_SOCK" "$SOCK"
    export SSH_AUTH_SOCK="$SOCK"
fi

function cv {
    if [ "$*" ]; then
        cd "$*" && f
    else
        cd && f
    fi
}

function policy {
    pkg=$(apt-cache search $1 | awk "BEGIN { shortest = \"\"; } \
                                    \$1 ~ /$1/ { \
                                    if (shortest == \"\" || length(\$1) < length(shortest)) \
                                        shortest = \$1; \
                                    } \
                                    END { print shortest; }")
    if [ -z $pkg ]; then
        echo "No packages matching '$1' found."
    else
        apt-cache policy $pkg | head -n 20
    fi
}

# xterm-256 color control sequences
SET_BG="\e[48;5;"
SET_FG="\e[38;5;"
END="m"

# Nice xterm-256color colors
PROMPT_COLOR=40
BG_COLOR=0
OUTPUT_COLOR=230
TIME_COLOR=140
USERHOST_COLOR=111
CMD_COLOR=250
SNOWMAN_COLOR=40

# \n - newline
# \$ - variable
# \[ \] surround characters not to be included in the length calculation
# \` \` surround command to be executed
export PS1="\[$SET_FG$TIME_COLOR$END\]\$LAST_LAUNCH_TIME\[$SET_FG$USERHOST_COLOR$END\]\u@\h:\[$SET_FG$PROMPT_COLOR$END\]\w \[$SET_FG$TIME_COLOR$END\](\$(git rev-parse --abbrev-ref HEAD 2>/dev/null))\[$SET_FG$SNOWMAN_COLOR$END\]☃ \[$SET_FG$CMD_COLOR$END\]"
export PROMPT_COMMAND='on_prompt'

LAST_LAUNCH_TIME=
function on_prompt() {
    # Do not trigger on completion
    [ -n "$COMP_LINE" ] && return
    tmux_pane
    # Save last launch time frame
    if [ -n "$LAST_LAUNCH_TIME" -a "$LAST_LAUNCH_TIME" != "$(date +'%T')" ]; then
        local newline=$'\n'
        local cur_time=$(date +'%s')
        local secs=$(($cur_time - $LAST_LAUNCH_UNIXTIME))
        sec="$(($secs % 60)) sec"
        local mins=$(($secs / 60))
        if [ $mins -gt 0 ]; then
            min="$(($mins % 60)) min "
        else
            min=""
        fi
        local hours=$(($mins / 60))
        if [ $hours -gt 0 ]; then
            hr="$hours h "
        else
            hr=""
        fi
        LAST_LAUNCH_TIME="[$LAST_LAUNCH_TIME - $(date +'%T') ($hr$min$sec)]$newline"
    else
        LAST_LAUNCH_TIME=""
    fi
    # For time tracking, we need to catch the first DEBUG trap          
    __interactive__=yes
    history -a # flush history into .bash_history
}
function before_command_execution() {
    if [ -n "$__interactive__" ]; then
        LAST_LAUNCH_TIME=$(date +'%T')
        LAST_LAUNCH_UNIXTIME=$(date +'%s')
        __interactive__=
    fi
}
trap 'before_command_execution' DEBUG

function complete_host {
    COMPREPLY=()

    if [[ ${COMP_CWORD} == 1 ]] ; then
        cur="${COMP_WORDS[COMP_CWORD]}"
        COMPREPLY=( $(compgen -W "$(curl -s https://c.yandex-team.ru/api/groups2hosts/maps_all)" -- ${cur}) )
        return 0
    fi
}

complete -F complete_host ssh
[ -e $HOME/sshp.sh ] && source $HOME/sshp.sh

PATH="/Users/ixanezis/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/ixanezis/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/ixanezis/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/ixanezis/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/ixanezis/perl5"; export PERL_MM_OPT;
