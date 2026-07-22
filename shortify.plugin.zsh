#!/usr/bin/env zsh

# Shortify
# Creates alias to simplify commands

alias b='bat -n'
alias bp='bat -p'
alias btctl='bluetoothctl'
alias df='df -h'
alias g='git'
alias ga='git add'
alias gst='git status'
alias h='fc -l'
alias ic='kitten icat'
alias j=jobs
alias l='ls'
alias m="$PAGER"
alias mv='mv -iv'
alias p='python'
alias po='popd'
alias s='ssh'
alias t='bsdtar'
alias v='nvim'

if [ $(uname) = "Linux" ]; then
	alias cp='cp -iv --reflink=auto'
	alias e='emerge'
	alias la='ls -la --human-readable'
	alias ll='ls -l --human-readable'
	alias ls='ls -F --color=auto --hyperlink=auto'
	alias se='sudo emerge'
	alias sv='sudoedit'
	scd () 
	{
		pushd $(qwhich -d $1 || echo . )
	}
else # Assume BSD userland bacause I don't have anything else
	alias cp='cp -iv'
	alias la="ls -lhao"
	alias ll="ls -lh"
	alias ls="ls -FG"
	# BSD specific functions
	scd ()
	{
		# cd into the port tree / source code for item
		pushd $( whereis -sq $1 || echo . )
	}
fi

# use z autojumping
export ZSHZ_CASE=smart
export ZSHZ_DATA="$HOME/.cache/z"
zz() {
    file=$(z -l $* | fzf --tac --no-multi | cut -d " " -f "2-" | xargs)
    pushd $file
}
alias zc="z -c"

# nnn shortcut
export NNN_PLUG='v:preview-tui'
n() {
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi
    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    nnn -ax -P 'v' "$@"
    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" >/dev/null
    fi
}

# get cheat sheet
cb() {
    curl -s cht.sh/$* | bat --decorations never
}

# Go to project root, https://blog.sushi.money/entry/20100211/1265879271
up()
{
    cd ./$(git rev-parse --show-cdup)
    if [ $# = 1 ]; then
        cd $1
    fi
}

# Highlight help messages https://github.com/sharkdp/bat#highlighting---help-messages
help() {
    "$@" --help 2>&1 | bat --plain --language=help
}
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# OSC support
function osc7-pwd() {
    emulate -L zsh # also sets localoptions for us
    setopt extendedglob
    local LC_ALL=C
    printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}

function chpwd-osc7-pwd() {
    (( ZSH_SUBSHELL )) || osc7-pwd
}

function precmd-osc-prompt-start() {
    if ! builtin zle; then
    	# End of output
        print -n "\e]133;D\e\\"
    fi

    # Prompt start
    print -Pn "\e]133;A\e\\"
}

function preexec-osc-output-start() {
    print -n "\e]133;C\e\\"
}

add-zsh-hook -Uz chpwd chpwd-osc7-pwd
add-zsh-hook -Uz precmd precmd-osc-prompt-start
add-zsh-hook -Uz preexec preexec-osc-output-start
