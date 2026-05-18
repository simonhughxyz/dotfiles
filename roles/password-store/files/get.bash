#!/bin/bash
#
# GET — retrieve a value from a YAML-format pass file.
#
# Expected file format:
#   <password>
#   ---
#   <yaml document>
#
# field argument:
#   pass        → line 1 (the password itself)
#   otpauth     → the otpauth field; -i interprets it via pass-otp
#   <jq-path>   → resolved by yq -r ".<field>" on the yaml portion
#                 (e.g. email.primary, nested.deep.leaf)

_usage="Usage: $(basename "$0") get [-pcntqifFw] field pass-name [chars-spec|menu]"
_help="$_usage
    -p              Print value (default)
    -c              Send to clipboard
    -n              Send as notification
    -q              Show as QR code
    -t              Type value
    -i              Interpret (e.g. otpauth → OTP via pass-otp)
    -f              Print as 'field: value'
    -F              Only print field name
    -w              Strip whitespace from field: value
    -h              Print this help message

Extra positional args (after field and pass-name) select nth chars of the
value, via cut -c. Pass 'menu' / 'm' to be prompted for the spec.
"

clip() {
    if [ -n "$WAYLAND_DISPLAY" ]; then
        wl-copy
    else
        xclip -selection clipboard
    fi
}

type_out() {
    if [ -n "$WAYLAND_DISPLAY" ]; then
        setsid -f wtype -s 200 -d 20 -- "$1" >/dev/null 2>&1
    else
        setsid -f xdotool sleep 0.1 type --clearmodifiers -- "$1" >/dev/null 2>&1
    fi
}

# extract nth chars (cut -c spec)
nth() {
    local value="$1"; shift
    local spec="$*"
    case "$spec" in
        m|menu)
            spec="$(printf '' | fzf --bind 'return:replace-query+print-query' --prompt 'Input the char numbers: ')"
            ;;
    esac
    [ -z "$spec" ] && return
    printf '%s' "$value" | cut -c "$spec"
}

# Build a jq path from a dotted field name, quoting segments with special
# chars (spaces, hyphens, …) so that ".Backup Codes" becomes ."Backup Codes".
jq_path_of() {
    local field="$1" expr="" seg
    local IFS=.
    for seg in $field; do
        if [[ "$seg" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
            expr+=".$seg"
        else
            expr+=".\"$seg\""
        fi
    done
    printf '%s' "$expr"
}

# yaml-aware retrieval. Array values are unwrapped to newline-separated items.
get() {
    local field="$1" file="$2"
    case "$field" in
        pass)
            # Everything above the `---` separator. Falls back to the whole
            # file if no separator is present.
            pass show "$file" | awk '/^---$/{exit} {print}'
            ;;
        *)
            local yaml expr
            yaml="$(pass show "$file" | awk 'f; /^---$/ {f=1}')"
            expr="$(jq_path_of "$field")"
            printf '%s\n' "$yaml" | yq -r "$expr | if type == \"array\" then .[] else . end // empty" 2>/dev/null
            ;;
    esac
}

while getopts 'hpcnqtifFw' OPTION; do
    case "$OPTION" in
    p) print=1 ;;
    c) clip=1 ;;
    n) notify=1 ;;
    q) qr=1 ;;
    t) type=1 ;;
    i) interpret=1 ;;
    f) printfield=1 ;;
    F) novalue=1 ;;
    w) nowhitespace=1 ;;
    h) printf '%s' "$_help"; exit ;;
    esac
done
shift "$((OPTIND - 1))"

FIELD="$1"
FILE="$2"
shift 2

# fetch raw value
if [ "$FIELD" = "otpauth" ] && [ "$interpret" = 1 ]; then
    value="$(pass otp "$FILE")"
else
    value="$(get "$FIELD" "$FILE")"
fi

# nth-char selection if extra args were passed
[ $# -gt 0 ] && value="$(nth "$value" "$@")"

# field-name formatting
if [ "$novalue" = 1 ]; then
    out="$FIELD"
elif [ "$printfield" = 1 ]; then
    if [ "$nowhitespace" = 1 ]; then
        out="$FIELD:$value"
    else
        out="$FIELD: $value"
    fi
else
    out="$value"
fi

# default action
[ -z "${print}${clip}${notify}${qr}${type}" ] && print=1

if [ -n "$out" ]; then
    [ "$print"  = 1 ] && printf '%s\n' "$out"
    [ "$clip"   = 1 ] && printf '%s' "$out" | clip
    [ "$notify" = 1 ] && notify-send "PASSWORD-STORE: $FILE" "$out"
    [ "$qr"     = 1 ] && ( qrencode -s 8 -o - <<<"$out" | setsid -f imv - >/dev/null 2>&1 ) &
    [ "$type"   = 1 ] && type_out "$out"
else
    exit 1
fi
