#!/bin/sh

# MENU
# Simon Hugh Moore
#
# Show a menu

history_nr=5    # number of history to display.

pass_dir="$HOME/.password-store"
runtime_dir="$XDG_RUNTIME_DIR/pass"
lastpass="$runtime_dir/lastpass" # store last pass accessed (pun intended)

mkdir -p $runtime_dir


_fzf(){
    fzf -i "$@"
}

# type out using xdotool
write(){
    # setsid xdotool sleep 0.1 type --clearmodifiers "$1" &
    setsid wtype -s 10 -d 20 "$1" &
    sleep 0.001
}

# Exploits a common design pattern in login fields to
# auto login by following the pattern of:
# type login --> press tab key --> type pass --> press return
auto_login(){
    login="$( pass get login "$password" )"
    pass="$( pass get pass "$password" )"

    setsid sh -c "xdotool sleep 0.1 type --clearmodifiers '$login';
                xdotool key Tab;
                xdotool type --clearmodifiers '$pass';
                xdotool key Return" &
    sleep 0.001
}

# Gets the nth chars from password.
# Some idiotic login field require the nth password.
# 
# If the the value in the key:value pair begins with '__'
# then use the rest of the string as a key.
# For example: `nth_login: __login` would look for `login: ...` to get the value.
_nth() {
    key="$( pass get "$1" "$password" )"
    [ "${key:0:2}" == "__" ] && key="${key:2}" || key="$1"
    pass nth get "$key" $( echo "" | _fzf --bind="enter:replace-query+print-query" --prompt "Input the char numbers you want: " ) "$password"
}

# got to password-store directory and get a list of files.
cd $pass_dir
password_files="$(find * -type f)"

# get pass file using menu
password=$( printf '%s\n' "$(tac "$lastpass" 2> /dev/null | awk 'NF' | awk '!x[$0]++' |head -n $history_nr)" "${password_files}" | sed 's|.gpg||' | _fzf ) || exit

# get options from pass file
options="$( pass $password | awk -F ':' '/^[0-9a-zA-Z_]*:.*$/{printf "%s\n", $1}' | sed 's/otpauth/OTP/')"

if [ "$options" != "" ]; then
    # choose what to get from pass file using fzf
    choice=$(printf "${auto}pass\n${options}" | _fzf ) || exit
else
    choice="pass"
fi

# store the chosen pass file name in lastpass file
echo "$password" >> "$lastpass"

case "$choice" in
    "*") auto_login;;                                        # autotype both login and pass
    OTP) write "$(pass otp show "$password")";;              # autotype OTP
    url*) write "$(pass get "$choice" "$password")";;        # autotype URL
    URL*) $BROWSER "$(pass get "$choice" "$password")";;     # visit URL
    # nth*) write "$(_nth "$choice")";;                        # autotype the nth char
    nth*) _nth "$choice";;                        # autotype the nth char
    Nth*) notify-send -u normal "Pass" "$(_nth "$choice")";; # display nth chars in notification
    *) write "$(pass get "$choice" "$password")";;
esac
