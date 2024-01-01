#!/bin/sh
# 
# MENU
# Simon Hugh Moore
#
# Show a menu

HISTORY=5
PASSWORD_STORE_DIR="${PASSWORD_STORE_DIR:-/home/$USER/.password-store}"
RUNTIME="$XDG_RUNTIME_DIR/pass"
LASTPASS="$RUNTIME/lastpass"
FZF_DEFAULT_OPTS_OLD="$FZF_DEFAULT_OPTS"
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --expect='return,alt-p,alt-c,alt-t,alt-n,alt-q,alt-u,alt-g,alt-f'"

mkdir -p $RUNTIME

# get list of password files
cd $PASSWORD_STORE_DIR
files="$( find * -type f | sed 's/\.gpg$//' )"

# get last passwords
# remove empty lines and duplicates
lastpasswords="$( tac "$LASTPASS" 2>/dev/null | awk NF | awk '!x[$0]++' | head -n "$HISTORY" )"

# get password choice
choice="$( printf "%s\%s" "$lastpasswords" "$files" | fzf )"

# seperate key from password file
key="$( printf "%s" "$choice" | sed -n '1p' )"
file="$( printf "%s" "$choice" | sed -n '2p' )"

# store the chosen pass file name in lastpass file
printf "%s\n" "$file" >> $LASTPASS

FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS_OLD
case "$key" in
    return)  pass choose "$file" ;;
    alt-p) pass get -p pass "$file" ;;
    alt-c) pass get -c pass "$file" ;;
    alt-t) pass get -t pass "$file" ;;
    alt-n) pass get -n pass "$file" ;;
    alt-q) pass get -q pass "$file" ;;

    alt-u) pass url "$file" ;;
    alt-g) BROWSER="chromium" pass url "$file" ;;
    alt-f) BROWSER="firefox" pass url "$file" ;;
esac
