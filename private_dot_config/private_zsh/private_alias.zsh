# ZSH alias

# Suffix
alias -s {mp4,MP4,mkv,MKV,mp3,MP3,mov,MOV,mpg,MPG,m4v,M4V,ogg,OGG,wav,WAV,webm,WEBM}='mpv'
alias -s {jpg,JPG,png,PNG,gif,GIF,tif,TIF,tiff,TIFF}='sxiv'
alias -s {pdf,PDF,ps,PS}='zathura'


# cd
alias d='dirs -v'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

# Global
alias -g NO='1> /dev/null'
alias -g NE='2> /dev/null'
alias -g NA='&> /dev/null'
alias -g G='| grep -i'
alias -g C='| wc -l'
alias -g W='| wc -w'
alias -g P='| awk -vRS= "END{print NR}"'
alias -g L='| less'
alias -g B='| bat'
alias -g H='| head'
alias -g T='| tail'
alias -g V='| vim -'
alias -g F='| fzf'
alias -g S='| sed "/^[[:space:]]*$/d"'

# print selected command from history.
fh() {
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
}
