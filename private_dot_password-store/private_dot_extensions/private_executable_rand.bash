#!/bin/sh

# NAME: rand
# AUTHOR: Simon Hugh Moore
# DATE: Wed 31 Aug 2022
# DESC: Generate cryptographicly secure random numbers, chars, words etc

default_length=10
rand_dev='/dev/urandom'
default_symbols='+_=)(][}{><?.,!£%^&*$;#:@~\-/\\'
delim="."
password_store="${PASSWORD_STORE_DIR:-${HOME}/.password-store}"
word_list="$( cat "${password_store}/eff_long.words" )"
word_list_short="$( cat "${password_store}/eff_short.words" )"
word_list_3="$( cat "${password_store}/eff_3.words" )"

__usage="usage: pass rand [OPTIONS, length]"
__help="$__usage

rand
Generate cryptographically secure random numbers, chars, symbols and words.
Uses $rand_dev as random source.

Options:
  -h, --help                         Print this help message
  -n [length]                        decimal number
  -a [length]                        alpha
  -l [length]                        lowercase
  -u [length]                        upercase
  -s [length]                        symbols
  -w [-d[delimiter]] [length]        EFF long word list
  -W [-d[delimiter]] [length]        EFF short word list
  -3 [-d[delimiter]] [length]        EFF short list with 3 unique character prefix
  -x [characters] [length]           using your own characters
  -X [length]                        using characters from PASSWORD_STORE_CHARACTER_SET env variable
"

default_length=${PASSWORD_STORE_GENERATED_LENGTH:-$default_length}
symbols="${PASSWORD_STORE_CHARACTER_SET_SYMBOLS:-$default_symbols}"
PASSWORD_STORE_CHARACTER_SET="${PASSWORD_STORE_CHARACTER_SET:-a-zA-Z0-9}"

rand(){
    <"$rand_dev" tr -dc "${character_set}" | tr -d '\n' | head -c "${1:-$default_length}"
}   

get_words(){
    printf "%s" "$1" | shuf --random-source="$rand_dev" -n "${2:-$default_length}"
}

rand_words(){
    list="$1"
    shift
    echo "$1"

    case "$delim" in
        "\n") get_words "$list" "$1" ;;
        "") get_words "$list" "$1" | tr -d '\n' ;;
        *) get_words "$list" "$1" | tr '\n' "$delim" | sed 's/.$/\n/' ;;
    esac

}

word=0
while getopts "hnalusx:XwW3d:" arg; do case $arg in
        h) printf "%s" "$__help"; exit ;;
        n) character_set="${character_set}0-9" ;;
        a) character_set="${character_set}a-zA-Z" ;;
        l) character_set="${character_set}a-z" ;;
        u) character_set="${character_set}A-Z" ;;
        s) character_set="${character_set}${symbols}" ;;
        x) character_set="${character_set}${OPTARG}" ;;
        X) shift ;;
        w) word=1; PASSWORD_STORE_WORD_LIST="${word_list_short}";;
        W) word=1; PASSWORD_STORE_WORD_LIST="${word_list}";;
        3) word=1; PASSWORD_STORE_WORD_LIST="${word_list_3}";;
        d) delim="${OPTARG}";;
esac done
shift $(($OPTIND - 1))

[ "$word" == 1 ] && rand_words "${PASSWORD_STORE_WORD_LIST}" "$@" || rand "$@"

