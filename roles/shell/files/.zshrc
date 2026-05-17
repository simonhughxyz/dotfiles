# Add deno completions to search path
if [[ ":$FPATH:" != *":/home/simon/.config/shell/completions:"* ]]; then export FPATH="/home/simon/.config/shell/completions:$FPATH"; fi
# Shell options
setopt GLOB_COMPLETE     # case insensitive globbing
setopt AUTO_CD           # change directory without cd
setopt AUTO_PUSHD        # Add cd into directory history
setopt PUSHD_IGNORE_DUPS # Ignore duplicate directories
# setopt CORRECT           # enable corrections
# setopt CORRECT_ALL
# setopt RM_STAR_WAIT # Ask for confirmation after 'rm *'
export REPORTTIME=5 # Report time for any command lasting more than 30 seconds

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history
setopt SHARE_HISTORY          # share history across multiple zsh sessions
setopt APPEND_HISTORY         # append to hist-file rather than override
setopt INC_APPEND_HISTORY     # update hist-file after every command
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicate commands first
setopt HIST_IGNORE_DUPS       # do not store duplicate commands
setopt HIST_FIND_NO_DUPS      # ignore duplicates when searching
setopt HIST_REDUCE_BLANKS     # remove blank lines from history

# Set default permission
umask 077 # leads to 600 for files and 700 for directories

# Source profile in non-login shells (login shells already get it via .zprofile)
[[ ! -o login ]] && source ~/.config/shell/profile

# autoload -U colors && colors
# setopt prompt_subst
# RPROMPT='$(prompt_git_status)'
# PROMPT='$(prompt_user_name)$(prompt_host_name)$(prompt_current_dir) $(prompt_exit_code)$(prompt_symbol)%f%b '


# Completion options (compinit is handled by plugin-list.zsh)
zstyle ':completion:*' menu select
zmodload zsh/complist  # needed for menuselect keymap
_comp_options+=(globdots)  # Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line


# First check if file exists before sourcing it.
_source() {
    [ -f $1 ] && source $1
}

# Load aliases and shortcuts if existent.
_source "$HOME/.config/shell/alias.sh"
_source "$HOME/.config/shell/alias.zsh"


source ~/.local/share/zsh/plugin-list.zsh
source /usr/share/fzf/key-bindings.zsh

#gpg
export GPG_TTY=$TTY

# zoxide - cache init script; regenerate if binary is newer than cache
if command -v zoxide > /dev/null; then
    _zoxide_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zoxide-init.zsh"
    if [[ ! -f "$_zoxide_cache" || "$(command -v zoxide)" -nt "$_zoxide_cache" ]]; then
        zoxide init zsh --cmd j > "$_zoxide_cache"
        zsh -c "zcompile '$_zoxide_cache'" 2>/dev/null
    fi
    source "$_zoxide_cache"
    alias cd='j'
    unset _zoxide_cache
fi



background_file="$XDG_RUNTIME_DIR/background"

background() {
  theme_hist_file="$XDG_CONFIG_HOME/.theme_history"

  if [ -e $theme_hist_file ]; then
    theme_last="$( tail -1 $theme_hist_file )"
    if echo "$theme_last" | grep -q "light"; then
      echo "light" > $background_file
    elif echo "$theme_last" | grep -q "dark"; then
      echo "dark" > $background_file
    fi
  fi
  set_background
}

set_background() {
  if [ -e $background_file ]; then
    export BACKGROUND="$( cat "$background_file" )"
  fi
}

if command -v theme.sh > /dev/null; then
	# [ -e ~/.theme_history ] && theme.sh "$(theme.sh -l|tail -n1)"
	[ -e "${XDG_CONFIG_HOME}/.theme_history" ] && theme.sh "$(theme.sh -l|tail -n1)"

	# Optional

	# Bind C-o to the last theme.
	last_theme() {
		theme.sh "$(theme.sh -l|tail -n2|head -n1)"
	}

	zle -N last_theme
	bindkey '^O' last_theme

	alias th='theme.sh -i'

	# Interactively load a light theme
	alias fthl='theme.sh --light -i'
	# alias thl='theme.sh gruvbox-light-hard'

	# Interactively load a dark theme
	alias fthd='theme.sh --dark -i'
	# alias thd='theme.sh gruvbox-dark-black-background'

  thl (){
    theme.sh gruvbox-light-hard
    background
  }

  thd (){
    theme.sh gruvbox-dark-black-background
    background
  }

  background

fi

set_background


# starship prompt - cache init script; regenerate if binary is newer than cache
_starship_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/starship-init.zsh"
if [[ ! -f "$_starship_cache" || "$(command -v starship)" -nt "$_starship_cache" ]]; then
    starship init zsh > "$_starship_cache"
    zsh -c "zcompile '$_starship_cache'" 2>/dev/null
fi
source "$_starship_cache"
unset _starship_cache
. "/home/simon/.deno/env"
