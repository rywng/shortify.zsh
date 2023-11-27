#!/usr/bin/env zsh

# Shortify
# Creates alias to simplify commands

alias b='bat -n'
alias btctl='bluetoothctl'
alias cp='cp -iv'
alias df='df -h'
alias e='emerge'
alias g='git'
alias info="info --vi-keys"
alias l='ls'
alias la='ls -la --human-readable'
alias ll='ls -l --human-readable'
alias mv='mv -iv'
alias p='python'
alias rm='trash'
alias s='kitten ssh'
alias se='sudo emerge'
alias sv='sudoedit'
alias v='nvim'

# use z autojumping
export ZSHZ_CASE=smart
export ZSHZ_DATA="$HOME/.cache/z"
zz() {
    cd $(z -l $* | fzf | awk '{print $2}')
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
