#!/bin/sh
# 
# CHOOSE
# Simon Hugh Moore
#
# allow user to choose what to do with password file using fzf

PASSWORD_STORE_DIR="${PASSWORD_STORE_DIR:-/home/$USER/.password-store}"
RUNTIME="$XDG_RUNTIME_DIR/pass"
LASTPASS="$RUNTIME/lastpass"

_usage="Usage: $(basename $0) choose pass-name"

_help="    alt-p       Print value
    alt-c       Send to clipboard
    alt-t       Type value
    alt-n       Send as notification
    alt-q       Open as qr code

    shift-*     do not interpret
    ctrl-*      nth character

    alt-?       Print this help message
"

FZF_HELP="$_help"
FZF_DEFAULT_OPTS_OLD="$FZF_DEFAULT_OPTS"
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --expect='return,alt-p,alt-c,alt-q,alt-n,alt-t,alt-P,alt-C,alt-Q,alt-T,alt-N,ctrl-alt-p,ctrl-alt-c,ctrl-alt-q,ctrl-alt-n,ctrl-alt-t,ctrl-alt-P,ctrl-alt-C,ctrl-alt-Q,ctrl-alt-T,ctrl-alt-N,alt-u,alt-f,alt-g' --bind='alt-?:toggle-preview' --preview-window='right,40%,hidden,<30(up,99%,hidden)' --preview='echo \"$FZF_HELP\"'"

FILE="$1"

open(){
    case "$field" in
        url) pass url "$FILE" ;;
        *) pass get -ip "$field" "$FILE" ;;
    esac
}

options="$( pass show "$FILE" | sed '1d' | grep '^[^:]*:' | sed 's/:.*$//' )"

choice="$( printf "%s\n%s" "pass" "$options" | fzf )"

key="$( printf "%s" "$choice" | sed -n '1p' )"
field="$( printf "%s" "$choice" | sed -n '2p' | tr '[[:upper:]]' '[[:lower:]]' )"
value="$( pass show "$FILE" | grep "^${option}:.*$" | sed 's/^[^:]*:[[:space:]]*//' )"

FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS_OLD
case "$key" in
    return) open ;;
    alt-p) pass get -imp "$field" "$FILE" ;;
    alt-c) pass get -imc "$field" "$FILE" ;;
    alt-t) pass get -imt "$field" "$FILE" ;;
    alt-n) pass get -ifmn "$field" "$FILE" ;;
    alt-q) pass get -imq "$field" "$FILE" ;;


    alt-P) pass get -mp "$field" "$FILE" ;;
    alt-C) pass get -mc "$field" "$FILE" ;;
    alt-T) pass get -mt "$field" "$FILE" ;;
    alt-N) pass get -fmn "$field" "$FILE" ;;
    alt-Q) pass get -mq "$field" "$FILE" ;;

    ctrl-alt-p) pass get -imp "$field" "$FILE" menu ;; # print nth char of value
    ctrl-alt-c) pass get -imC "$field" "$FILE" menu ;; # print nth char of value
    ctrl-alt-t) pass get -imt "$field" "$FILE" menu ;; # print nth char of value
    ctrl-alt-n) pass get -ifmn "$field" "$FILE" menu ;; # print nth char of value
    ctrl-alt-q) pass get -imq "$field" "$FILE" menu ;; # print nth char of value

    ctrl-alt-P) pass get -mp "$field" "$FILE" menu ;; # print nth char of value
    ctrl-alt-C) pass get -mC "$field" "$FILE" menu ;; # print nth char of value
    ctrl-alt-T) pass get -mt "$field" "$FILE" menu ;; # print nth char of value
    ctrl-alt-N) pass get -fmn "$field" "$FILE" menu ;; # print nth char of value
    ctrl-alt-Q) pass get -mq "$field" "$FILE" menu ;; # print nth char of value

    alt-u) pass url "$FILE" ;;
    alt-g) BROWSER="chromium" pass url "$FILE" ;;
    alt-f) BROWSER="firefox" pass url "$FILE" ;;
esac
