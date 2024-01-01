#!/bin/sh

# ALIAS
# Simon Hugh Moore
#
# Defines all my shell aliases to use.

# shortcuts 
alias sudo='sudo '
alias se='sudoedit '
alias path='echo $PATH'
alias x='clear '
alias p='sudo pacman '
alias xi='sudo xbps-install '
alias xr='sudo xbps-remove '
alias xq='xbps-query '
alias xl='xlocate -S; xlocate '
alias sv='sudo sv '
alias svr='sudo sv restart '
alias svs='sudo sv stop '
alias clip='xclip -selection clipboard'
alias paste='xclip -o'
alias bt='bluetoothctl'
alias o='xdg-open '
alias nftl='sudo nft list ruleset'
alias nftf='sudo nft flush ruleset'
alias nfts='sudo nft -f /etc/nftables.conf'
alias vpnu='wg-quick up '
alias vpnd='wg-quick down '
alias dot="git --git-dir=$HOME/Projects/dotfiles.git --work-tree=$HOME"

# program options
alias mbsync='mbsync -c "$XDG_CONFIG_HOME"/mbsync/mbsyncrc'
alias newsboat='newsboat -I ~/sync/newsboat/read.newsboat; newsboat '
alias cal='cal -m -3'

# ls
# alias ls='ls --color=auto --group-directories-first'
alias ls='exa --icons --group-directories-first'
alias l='ls'
alias l.='ls -d .*'
alias l,='ls -a'
# ls only directories
alias ld='ls -d */'
alias ld.='ls -d .*/'
alias ld,='ls -d */ .*/'
# ls in list format
alias ll='ls -lh'
alias ll.='ll -d .*'
alias ll,='ll -a'
# ls directories in list format
alias lld='ll -d */'
alias lld.='ll -d .*/'
alias lld,='ll -d */ .*/'

# cd
alias c='cd '
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias cddl="cd $DOWNLOADS"
alias cddoc="cd $DOCUMENTS"
alias cdpic="cd $PICTURES"
alias cdvid="cd $VIDEOS"
alias cddot="cd $DOTFILES"
alias cdconf="cd $CONFIG"
alias cdwh="cd $WH"
alias fcd=". fcd"
mcd() { mkdir "$1"; cd "$1"; }  # make dir and cd into it.
b(){ cd "$(bk -L | fzf)"; }


# vim
alias vim='nvim'
alias vi='vim'
alias v='vim'
alias vg='gvim'
alias vw='vim -c VimwikiIndex '

# git
alias g='git'
alias gs='git status'
alias gb='git branch'
alias ga='git add'
alias gc='git commit'
alias gch='git checkout'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --graph --abbrev-commit --pretty=oneline --decorate'
alias gf='git fetch'
alias gm='git merge'
alias gd='git diff'

# Utils
alias grep='grep --color=auto '
alias diff='diff --color=auto'
alias fd='fd -H '
alias rg='rg --color=auto --hidden'

# stardict
alias def='sdcv --color'
alias defen='def -u "dictd_www.dict.ogrep_gcide"'
alias defel='def -u "dictd_www.dict.ogrep_elements"'
alias defcomp='def -u "Free On-Line Dictionary of Computing"'
alias defde='def -u "German - English" -u "English - German"'

# system info
alias free='free -hlt'
alias free1000='free -hlt --si' # display using power of 1000 instead 1024
alias ps='ps auxf'
alias psq='ps auxf | grep -v grep | grep -i -e "PID %CPU %MEM" -e' 
alias tree2="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"

# networking
alias ipinfo='curl ifconfig.me/all && echo ""'
alias myip='curl ifconfig.me/ip; echo'
alias ipt='sudo iptables'
alias ip6t='sudo ip6tables'
alias iptl='sudo iptables -nvL'
alias ip6tl='sudo ip6tables -nvL'

# trash
alias r='trash-put '
alias rl='trash-list '
alias rc='trash-list | wc -l'
alias rr='trash-restore '
alias rrm=' trash-rm '

# misc
alias rm='rm -I '
alias hist='history | g'
alias busy="cat /dev/urandom | hexdump -C | grep \"ca fe\""
alias du='du -d1 -h'  # max depth and human readable.
alias dus='du | sort -h'  # sort by filesize.
alias dud='\du -sh -c ./*/ | sort -h' # Only directories and sort.
alias df='df -hT --total' # human readable, print filetype and total.
alias ln='ln -iv' # asks to override file and verbose.
alias mkdir='mkdir -pv'     # Add parent dir on demand
alias qcp='qcp -f do'   # Destination column only.
alias qmv='qmv -f do'   # Destination column only.
alias rsync='rsync -vh --progress' # verbose, human readable and show progress.
alias rq='rsync -aHAXxv --progress --delete --progress -e "ssh -T -o Compression=no -x"' # quick sync for local network
alias mnt="sudo mount -o uid=$(whoami),gid=$(whoami)"

# functions

# Color for manpages
man() {
  env LESS_TERMCAP_mb=$'\E[01;31m' \
  LESS_TERMCAP_md=$'\E[01;31m' \
  LESS_TERMCAP_me=$'\E[0m' \
  LESS_TERMCAP_se=$'\E[0m' \
  LESS_TERMCAP_so=$'\E[01;44;33m' \
  LESS_TERMCAP_ue=$'\E[0m' \
  LESS_TERMCAP_us=$'\E[01;32m' \
  man "$@"
}

fman() {
    man $(man -k . | fzf --prompt='Man> ' --preview="man \$(echo {} | awk '{print \$1}')" | awk '{print $1}')
}

# use correct command to extract.
extract() { 
    if [ -f $1 ] ; then 
      case $1 in 
        *.tar.bz2)   tar xjf $1     ;; 
        *.tar.gz)    tar xzf $1     ;; 
        *.bz2)       bunzip2 $1     ;; 
        *.rar)       unrar e $1     ;; 
        *.gz)        gunzip $1      ;; 
        *.tar)       tar xf $1      ;; 
        *.tbz2)      tar xjf $1     ;; 
        *.tgz)       tar xzf $1     ;; 
        *.zip)       unzip $1       ;; 
        *.Z)         uncompress $1  ;; 
        *.7z)        7z x $1        ;; 
        *)     echo "'$1' cannot be extracted via extract()" ;; 
         esac 
     else 
         echo "'$1' is not a valid file" 
     fi 
}

# Hash checks
hashcheck() {
    md5sum -c "$1"
    sha1sum -c "$1"
    sha256sum -c "$1"
}
