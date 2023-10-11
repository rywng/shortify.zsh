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
alias vim='nvim'

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

# doas edit
# taken from https://github.com/AN3223/scripts/blob/master/doasedit
doasedit() {
	help() {
		cat - >&2 <<EOF
doasedit - like sudoedit, but for doas

doasedit file...

Every argument will be treated as a file to edit. There's no support for
passing arguments to doas, so you can only doas root.

This script is SECURITY SENSITIVE! Special care has been taken to correctly
preserve file attributes. Please exercise CAUTION when modifying AND using
this script.
EOF
	}

	case "$1" in --help | -h)
		help
		return 0
		;;
	esac

	export TMPDIR=/dev/shm/
	trap 'trap - EXIT HUP QUIT TERM INT; rm -f "$tmp" "$tmpcopy"' EXIT HUP QUIT TERM INT

	for file; do
		case "$file" in -*) file=./"$file" ;; esac

		tmp="$(mktemp)"
		if [ -f "$file" ] && [ ! -r "$file" ]; then
			doas cat "$file" >"$tmp"
		elif [ -r "$file" ]; then
			cat "$file" >"$tmp"
		fi

		tmpcopy="$(mktemp)"
		cat "$tmp" >"$tmpcopy"

		${EDITOR:-vi} "$tmp"

		if cmp -s "$tmp" "$tmpcopy"; then
			echo 'File unchanged, exiting...'
		else
			doas dd if="$tmp" of="$file"
			echo 'Done, changes written'
		fi

		shred -u "$tmp" "$tmpcopy"
	done

}
