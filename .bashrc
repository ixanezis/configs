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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

tmux_pane() {
    hostname=$(hostname)
    hostname_prefix=${hostname%%.*}
    basename=$(basename $(pwd))
    printf "\033k$hostname_prefix:$basename\033\\"
}

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1 "
    ;;
*)
    ;;
esac

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

alias ff='ls -Ahl'
alias f='ff'
alias v='vim -X'
alias vs='v'
alias tt="tmux -u attach -d || tmux -u"
alias dupload="dupload --nomail"
alias psql="PAGER=less LESS='-iMSx4 -FX' psql"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export DEBFULLNAME="Sergei Zhgirovski"
export DEBEMAIL="ixanezis@yandex-team.ru"
alias dch='dch --distributor=debian'

alias cdl='cd /home/ixanezis/mapscore/masstransit/lib/'
alias cdli='cd /home/ixanezis/mapscore/masstransit/lib/include/yandex/maps/masstransit/'
alias cdr='cd /home/ixanezis/mapscore/masstransit/router/'
alias cdp='pushd /home/ixanezis/mapscore/masstransit/pedestrian_graph/'
alias i='pushd ~/mapscore/masstransit/info'
alias le='pushd /home/ixanezis/mapscore/routing/leptidea-connector'
alias s='pushd ~/mapscore/jams/aggregation/scripts'
alias h='pushd ~/mapscore/hotspots/spotsvis'
alias t='pushd ~/mapscore/jams/tools/draw-prognosis'
alias r='pushd ~/mapscore/masstransit/quality2 >/dev/null'
alias z='pushd ~/mapscore/jams/visualization/configs/fastcgi-prognosis'
alias j='pushd ~/mapscore/fastcgi/tilerenderer-serv/hotspots/jams'
alias p='pushd ~/mapscore/pymod/yandex/maps/poi'
alias ☃='sl -a'
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
alias po=policy

# alias gitdiff='git diff | /home/ixanezis/linenum.py'
function gitdiff {
    git diff $* | /home/ixanezis/linenum.py
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
#export PS1="\[$SET_BG$BG_COLOR$END$SET_FG$TIME_COLOR$END\]\$LAST_LAUNCH_TIME\[$SET_FG$PROMPT_COLOR$END\]$PWD>\[$SET_FG$COMMAND_COLOR$END\] "
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
