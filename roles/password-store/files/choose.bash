#!/bin/bash
#
# CHOOSE — pick a field path in a YAML-format pass file, drilling into
# arrays when needed, then dispatch to `pass get`.
#
# Expected file format:
#   <password>
#   ---
#   <yaml document>
#
# At the top level fzf shows `pass` (the password section) plus every
# scalar leaf and array as a dotted jq path. Picking an array with Enter
# opens a sub-menu of its items (`N: value`); the loop repeats until the
# selection is a scalar (or an action key is pressed).
#
# Keys:
#   <enter>     for scalar: default action (copy / open url)
#               for array:  drill into items
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

paths="$(printf '%s\n' "$yaml" | yq -r '
  def leafpaths:
    if type == "object" then to_entries[] | [.key] + (.value | leafpaths)
    else [] end;
  leafpaths | join(".")
' 2>/dev/null | awk 'NF')"

# Build a jq path expression from a dotted field name. Numeric segments
# become array indices; segments with special chars get quoted.
jq_path_of() {
    local field="$1" expr="" seg
    local IFS=.
    for seg in $field; do
        if [[ "$seg" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
            expr+=".$seg"
        elif [[ "$seg" =~ ^[0-9]+$ ]]; then
            expr+="[$seg]"
        else
            expr+=".\"$seg\""
        fi
    done
    printf '%s' "$expr"
}

FZF_DEFAULT_OPTS_OLD="$FZF_DEFAULT_OPTS"
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --expect='return,alt-p,alt-c,alt-t,alt-n,alt-q,alt-P,alt-C,alt-T,alt-N,alt-Q,alt-u,alt-g,alt-f'"

choice="$(printf 'pass\n%s' "$paths" | fzf --prompt "$FILE > ")"
[ -z "$choice" ] && exit 0
key="$(printf '%s' "$choice"   | sed -n 1p)"
field="$(printf '%s' "$choice" | sed -n 2p)"
[ -z "$field" ] && exit 0

# Drill into arrays as long as Enter is pressed.
while [ -z "$key" ] && [ "$field" != "pass" ]; do
    jqp="$(jq_path_of "$field")"
    type="$(printf '%s\n' "$yaml" | yq -r "$jqp | type" 2>/dev/null)"
    [ "$type" != "array" ] && break

    items="$(printf '%s\n' "$yaml" | yq -r \
        "$jqp | to_entries | .[] | \"\(.key): \(.value | tostring)\"" 2>/dev/null)"
    choice="$(printf '%s\n' "$items" | fzf --prompt "$FILE > $field > ")"
    [ -z "$choice" ] && exit 0
    key="$(printf '%s' "$choice"   | sed -n 1p)"
    sel="$(printf '%s' "$choice"   | sed -n 2p)"
    [ -z "$sel" ] && exit 0

    idx="${sel%%:*}"
    field="$field.$idx"
done

FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS_OLD"

open_default() {
    case "$field" in
        url|*.url) pass url "$FILE" ;;
        *)         pass get -ic "$field" "$FILE" ;;
    esac
}

case "$key" in
    return|"") open_default ;;
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
