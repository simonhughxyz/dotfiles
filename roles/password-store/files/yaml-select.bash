#!/bin/bash
# yaml-select — pick a field in a YAML-format pass file and act on its value.
#
# Expected file format:
#   <password>
#   ---
#   <yaml document, arbitrary depth>
#
# fzf shows <password> plus every scalar leaf as a dotted jq-style path.
#
# Key bindings:
#   <enter>        copy value to clipboard (default action)
#   alt-p          print
#   alt-c          copy
#   alt-t          type out
#   alt-n          send as notification
#   alt-q          show as QR code
#   alt-{P,C,T,N,Q}  same actions, but on user-selected nth chars (cut -c spec)

set -u

FILE="${1:-}"
[ -z "$FILE" ] && { echo "Usage: pass yaml-select <pass-name>" >&2; exit 2; }

CONTENT="$(pass show "$FILE")" || exit 1
PASSWORD="$(printf '%s\n' "$CONTENT" | head -n 1)"
YAML="$(printf '%s\n' "$CONTENT" | awk 'f; /^---$/ {f=1}')"

# Every scalar leaf as a dot-joined jq path (e.g. "email.primary")
PATHS="$(printf '%s\n' "$YAML" | yq -r 'paths(scalars) | join(".")' 2>/dev/null | awk 'NF')"

choice="$(printf '<password>\n%s\n' "$PATHS" | fzf \
  --prompt "$FILE > " \
  --expect='alt-p,alt-c,alt-t,alt-n,alt-q,alt-P,alt-C,alt-T,alt-N,alt-Q')"
[ -z "$choice" ] && exit 0
key="$(printf '%s' "$choice" | sed -n 1p)"
sel="$(printf '%s' "$choice" | sed -n 2p)"
[ -z "$sel" ] && exit 0

if [ "$sel" = "<password>" ]; then
  value="$PASSWORD"
else
  value="$(printf '%s\n' "$YAML" | yq -r ".${sel}")"
fi

# Nth-char variants: capitalised action keys prompt for a `cut -c` range spec.
case "$key" in
  alt-P|alt-C|alt-T|alt-N|alt-Q)
    ranges="$(printf '' | fzf \
      --print-query \
      --prompt 'nth chars (e.g. 1,3-5): ' \
      --bind 'return:print-query+abort' 2>/dev/null | sed -n 1p)"
    [ -z "$ranges" ] && exit 0
    value="$(printf '%s' "$value" | cut -c "$ranges")"
    key="$(printf '%s' "$key" | tr 'PCTNQ' 'pctnq')"
    ;;
esac

# Default action: copy
[ -z "$key" ] && key="alt-c"

clip() {
  if [ -n "${WAYLAND_DISPLAY:-}" ]; then
    printf '%s' "$1" | wl-copy
  else
    printf '%s' "$1" | xclip -selection clipboard
  fi
}

type_out() {
  if [ -n "${WAYLAND_DISPLAY:-}" ]; then
    setsid -f wtype -s 200 -d 20 -- "$1" >/dev/null 2>&1
  else
    setsid -f xdotool sleep 0.1 type --clearmodifiers -- "$1" >/dev/null 2>&1
  fi
}

qr_show() {
  ( qrencode -s 8 -o - <<<"$1" | setsid -f imv - >/dev/null 2>&1 ) &
}

case "$key" in
  alt-p) printf '%s\n' "$value" ;;
  alt-c) clip "$value" ;;
  alt-t) type_out "$value" ;;
  alt-n) notify-send "pass: $FILE" "$value" ;;
  alt-q) qr_show "$value" ;;
esac
