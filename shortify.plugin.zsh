#!/usr/bin/env zsh

# Shortify
# Creates alias to simplify commands

alias b='bat -n'
alias btctl='bluetoothctl'
alias cp='cp -iv'
alias df='df -h'
alias e='emerge'
alias ffva='ffmpeg -hwaccel vaapi -hwaccel_output_format vaapi -hwaccel_device /dev/dri/renderD128'
alias g='git'
alias info="info --vi-keys"
alias l='ls'
alias la='ls -la --human-readable'
alias ll='ls -l --human-readable'
alias mv='mv -iv'
alias nya='doas'
alias p='python'
alias rm='trash'
alias s='kitten ssh'
alias se='doas emerge'
alias sv='doasedit'
alias uwu='doas'
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

#start mpv detached
dmpv() {
	mpv $* &>/dev/null &
	disown
}
