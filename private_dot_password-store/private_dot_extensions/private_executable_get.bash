#!/bin/bash

# GET
# Simon Hugh Moore
#
# Retrive data from pass file
# 
# Data must be organized in the file like so:
# meta_name: data
# for example:
# login: user_name

_usage="Usage: $(basename $0) get [-p] [-c] [-n] [-q] [-t] [-i] [-f] [-F] [-m] [-M] pass-name [numbers|menu]"
_help="$_usage
    -p              Print value (default)
    -n              Send as notification
    -q              Open as qr code
    -t              Type value
    -i              Interpret value
    -f              Print field name with value
    -F              Only print field name
    -m              Include multiline fields
    -M              Only multiline fields
    -w              Don't use white space for formatting
    -h              Print this help message

Note:
    - \`pass\` is a special field name to print the first line (the password) of the pass file
    - \`otpauth\` does not require a key (because of the way pass-otp handles otpauth)
    - a field name can have any character except \`:\`
    - a multiline field is any field name with no value following \`:\`, all following lines are considered the value until an empty line
"

# send to clipboard using wl-copy or xclip
clip(){
    if [ -n "$WAYLAND_DISPLAY" ]; then
        wl-copy
    else
        xclip
    fi
}

# type out using wtype or xdotool
type(){
    if [ -n "$WAYLAND_DISPLAY" ]; then
        setsid sh -c "wtype -s 200 -d 20 '$1' &"
    else
        setsid sh -c "xdotool sleep 0.1 type --clearmodifiers '$1' &"
    fi
}

# get the nth characters
nth(){
    numbers="$@"

    # get char numbers with fzf
    case "$numbers" in
        m|menu) numbers="$( printf "" | fzf --bind="return:replace-query+print-query" --prompt "Input the char numbers: " )"
    esac
    
    if [ "$printfield" == 1 ]; then
        if [ "$singleline" == 1 ]; then
            slines="$( singleline=1 multiline=0 get "$FIELD" "$FILE" )"

            slines_field="$( printf "$slines" | cut -d':' -f1 | sed 's/.*/&:/' )"
            slines_value="$( printf "$slines" | cut -d':' -f2 | cut -c "$numbers" )"
            slines="$( paste <( printf "$slines_field" ) <( printf "$slines_value" ) )"

            if [ "$nowhitespace" == 1 ]; then
                slines="$( printf "%s\n" "$slines" | sed 's/:[[:space:]]*/:/' )"
            else
                slines="$( printf "%s\n" "$slines" | sed 's/:[[:space:]]*/: /' )"
            fi
        fi

        if [ "$multiline" == 1 ]; then
            mlines="$( singleline=0 multiline=1 printfield=0 novalue=0 get "$FIELD" "$FILE" | cut -c "$numbers" )"

            [ "$nowhitespace" != 1 ] && mlines="$( printf "$mlines" | sed 's/^/  /' )"

            while IFS= read -r line; do
                field="$( printf "%s" "$line" | sed 's/.*/&:/' )"
                mlines="$( printf "$mlines" | sed "0,/^[[:space:]]*\$/s/^[[:space:]]*\$/${field}/" )"
            done <<EOF
$( singleline=0 multiline=1 printfield=0 novalue=1 get "$FIELD" "$FILE" )

            mlines="$( printf "$mlines" | sed 's/^[^:][^:]*:/\'$'\n&/' )"
EOF
        fi

            printf "%s" "$slines"
            [ -n "$slines" ] && [ -n "$mlines" ] && printf "\n"
            printf "%s" "$mlines"
    else
        get "$FIELD" "$FILE" | cut -c "$numbers"
    fi
}

# get value and/or field from passfile
get(){
    if [ "$1" = "pass" ]; then
        pass show "$2" | head -n 1
    else

        if printf "$1" | grep -c '^[^:][^:]*:..*$' >/dev/null; then
            mfield="$( printf "$1" | cut -d':' -f1 )"
            cfield="$( printf "$1" | sed 's/^[^:][^:]*://' )"
            
            echo "$mfield"
            echo "$cfield"
            exit
        fi

        # pre-process content
        content="$( pass show "$2" )"
        [ "$singleline" == 1 ] && line="$( printf "$content" | grep -i "^${1}[^:]*:..*$" )"
        # [ "$multiline" == 1 ] && mline="$( printf "$content" | sed "/^[^:][^:]*:..*\$/d" | awk -v RS="" -v ORS="\n" "/^${1}[^:]*:/{print}" | sed 's/^[[:space:]]*//' )"
        [ "$multiline" == 1 ] && mline="$( printf "$content" | awk -v RS="" -v ORS="\n" "/^${1}[^:]*:\n/{print}" | sed 's/^[[:space:]]*//' )"

        if [ "$printfield" == 1 ]; then # print field names with value
            [ "$singleline" == 1 ] && line="$(printf "%s" "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sed 's/[[:space:]]*:[[:space:]]*/:/;s/:/: /')"

        elif [ "$novalue" == 1 ]; then # only print field names
            [ "$singleline" == 1 ] && line="$(printf "%s" "$line" | sed 's/:.*$//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
            [ "$multiline" == 1 ] && mline="$( printf "%s" "$mline" | grep -i "${1}[^:]*:" | sed 's/:.*$//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

        else # only print value
            [ "$singleline" == 1 ] && line="$(printf "%s" "$line" | sed 's/^[^:]*:[[:space:]]*//;s/[[:space:]]*$//')"
            [ "$multiline" == 1 ] && mline="$(printf "%s" "$mline" | sed 's/^[^:][^:]*:$//' )"
        fi

        # Format output
        printf "%s" "$line"
        [ -n "$line" ] && [ -n "$mline" ] && printf "\n"
        [ -n "$mline" ] && printf "%s" "$mline"
    fi
}

singleline=1
while getopts 'hpcnqtifFmMwl' OPTION; do
    case "$OPTION" in
    p) print=1 ;;
    c) clip=1 ;;
    n) notify=1 ;;
    q) qr=1 ;;
    t) type=1 ;;
    i) interpret=1 ;;
    f) printfield=1 ;;
    F) novalue=1 ;;
    m) multiline=1 ;;
    M) multiline=1; singleline=0 ;;
    w) nowhitespace=1 ;;
    h) printf "%s" "$_help" ; exit;;
    esac
    shift "$(($OPTIND -1))"
done

FIELD="$1"
FILE="$2"
value="$( get "$FIELD" "$FILE" )"
shift 2

# if [ -z "$value" ]; then
#     pass show "$FILE" | awk -v RS="" -v ORS="\n" "/${FIELD}/{print}"
#     exit
# fi

# handle special case for opt auth
[ "$FIELD" == "otpauth" ] && value="otpauth:${value}"

# if interpret flag is set, get otp from otpauth
if [ "$interpret" = 1 ]; then
    case "$FIELD" in
        otpauth) value="$( pass otp "$FILE" )"
    esac
fi

# get nth characters
[ $# -gt 0 ] && value="$( nth $@ )"

# default to print
[ -z "${print}${clip}${notify}${qr}${type}" ] && print=1

if [ -n "$value" ]; then
    [ "$print" = 1 ] && printf "%s\n" "$value"
    [ "$clip" = 1 ] && printf "%s\n" "$value" | clip
    [ "$notify" = 1 ] && notify-send "PASSWORD-STORE: $FILE" "$value"
    [ "$qr" = 1 ] && setsid -f sh -c "qrencode '$value' -s 8 -o - | imv - &"
    [ "$type" = 1 ] && type "$value"
else
    exit 1
fi
