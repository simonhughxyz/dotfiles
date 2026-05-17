#!/bin/sh
#
# .profile

if [ -z "$XDG_CONFIG_HOME" ];then
  export XDG_CONFIG_HOME="$HOME/.config/"
fi

source "$XDG_CONFIG_HOME/shell/profile"
. "/home/simon/.deno/env"
