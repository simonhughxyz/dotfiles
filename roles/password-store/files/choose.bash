#!/bin/bash
#
# CHOOSE — pick a field in a YAML-format pass file, dispatch to `pass get`.
#
# Expected file format:
#   <password>
#   ---
#   <yaml document>
#
# fzf surfaces 'pass' (line 1) plus every scalar leaf in the yaml as a
# dotted jq path. Selecting one + a key combo shells out to `pass get`.
#
# Keys:
#   <enter>     copy (default for non-url fields) / open url (if field is 'url')
#   alt-p       print
#   alt-c       clip
#   alt-t       type
#   alt-n       notify (with field name)
#   alt-q       qr code
#   alt-P/C/T/N/Q   same actions, but prompts for nth-char range (cut -c spec)
#   alt-u       open url field in $BROWSER
#   alt-g       open url field in chromium
#   alt-f       open url field in firefox

FILE="$1"

yaml="$(pass show "$FILE" | awk 'f; /^---$/ {f=1}')"
paths="$(printf '%s\n' "$yaml" | yq -r 'paths(scalars) | join(".")' 2>/dev/null | awk 'NF')"

FZF_DEFAULT_OPTS_OLD="$FZF_DEFAULT_OPTS"
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --expect='return,alt-p,alt-c,alt-t,alt-n,alt-q,alt-P,alt-C,alt-T,alt-N,alt-Q,alt-u,alt-g,alt-f'"

choice="$(printf 'pass\n%s' "$paths" | fzf --prompt "$FILE > ")"
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS_OLD"

[ -z "$choice" ] && exit 0
key="$(printf '%s' "$choice"   | sed -n 1p)"
field="$(printf '%s' "$choice" | sed -n 2p)"
[ -z "$field" ] && exit 0

open_default() {
    case "$field" in
        url|*.url) pass url "$FILE" ;;
        *)         pass get -ic "$field" "$FILE" ;;
    esac
}

case "$key" in
    return) open_default ;;
    alt-p)  pass get -ip  "$field" "$FILE" ;;
    alt-c)  pass get -ic  "$field" "$FILE" ;;
    alt-t)  pass get -it  "$field" "$FILE" ;;
    alt-n)  pass get -ifn "$field" "$FILE" ;;
    alt-q)  pass get -iq  "$field" "$FILE" ;;

    alt-P)  pass get -ip  "$field" "$FILE" menu ;;
    alt-C)  pass get -ic  "$field" "$FILE" menu ;;
    alt-T)  pass get -it  "$field" "$FILE" menu ;;
    alt-N)  pass get -ifn "$field" "$FILE" menu ;;
    alt-Q)  pass get -iq  "$field" "$FILE" menu ;;

    alt-u)  pass url "$FILE" ;;
    alt-g)  BROWSER="chromium" pass url "$FILE" ;;
    alt-f)  BROWSER="firefox"  pass url "$FILE" ;;
esac
