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

source ~/.config/shell/profile

# Prompt
# Git status
prompt_git_status() {
    f_color="5"
    f_color_staged="yellow"
    f_color_unstaged="red"

    local message=""
    local message_color="%F{$f_color}"

    # https://git-scm.com/docs/git-status#_short_format
    local staged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU]")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU? ][MADRCU?]")

    if [[ -n ${staged} ]]; then
        message_color="%F{$f_color_staged}"
    elif [[ -n ${unstaged} ]]; then
        message_color="%F{$f_color_unstaged}"
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n ${branch} ]]; then
        message+="${message_color}${branch}%f"
    fi

    echo -n "${message}"
}

prompt_current_dir() {
    f_color="yellow"
    last_path="1" # last nr of elements of path to show.
    echo "%F{$f_color}%$last_path~%f" 
}

prompt_user_name() {
    f_color="green"
    f_seperator_color="blue"
    last_path="1" # last nr of elements of path to show.
    DEFAULT_USER="simon"
    if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
        echo "%F{$f_color}%n%f%F{$f_seperator_color}@%f" 
    fi
}

prompt_host_name() {
    f_color="green"
    f_seperator_color="blue"
    last_path="1" # last nr of elements of path to show.
    DEFAULT_HOST="voidbook"
    if [[ "$HOST" != "$DEFAULT_HOST" || -n "$SSH_CLIENT" ]]; then
        echo "%F{$f_color}%m%f%F{$f_seperator_color}:%f" 
    fi
}

prompt_symbol() {
    f_color="blue"
    f_sudo_color="red"
    echo "%(!.%F{$f_sudo_color}#.%F{$f_color}>)%f"
}

prompt_exit_code() {
    f_color="red"
    echo "%F{$f_color}%(?..%? )%f"
}

autoload -U colors && colors
setopt prompt_subst
RPROMPT='$(prompt_git_status)'
PROMPT='$(prompt_user_name)$(prompt_host_name)$(prompt_current_dir) $(prompt_exit_code)$(prompt_symbol)%f%b '


# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

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

n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}


# First check if file exists before sourcing it.
_source() {
    [ -f $1 ] && source $1
}

# Load aliases and shortcuts if existent.
_source "$HOME/.config/shell/alias.sh"
_source "$HOME/.config/shell/alias.zsh"

# Load autojump
_source /usr/share/autojump/autojump.zsh

# Load fzf
_source ~/.fzf.zsh

# Load autosuggestions
# _source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Load zsh-syntax-highlighting; should be last.
# _source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

source $ZPLUG_HOME/init.zsh

zplug "reegnz/jq-zsh-plugin"
zplug "zsh-users/zsh-autosuggestions"
zplug "marlonrichert/zsh-autocomplete"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "zdharma-continuum/fast-syntax-highlighting"

# Install only if not already installed
if ! zplug check --verbose; then
    echo "Installing missing plugins..."
    zplug install
fi

zplug load

#gpg
export GPG_TTY=$(tty)

# zoxide
if command -v zoxide > /dev/null; then
    eval "$( zoxide init zsh --cmd j )"
    eval "$( zoxide init zsh --cmd cd )"
fi

export LEDGER_FILE=toc.ledger



#compdef invoice
compdef _invoice invoice

# zsh completion for invoice                              -*- shell-script -*-

__invoice_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_invoice()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16
    local shellCompDirectiveKeepOrder=32

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace keepOrder
    local -a completions

    __invoice_debug "\n========= starting completion logic =========="
    __invoice_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __invoice_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __invoice_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., invoice -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __invoice_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __invoice_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __invoice_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __invoice_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __invoice_debug "No directive found.  Setting do default"
        directive=0
    fi

    __invoice_debug "directive: ${directive}"
    __invoice_debug "completions: ${out}"
    __invoice_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __invoice_debug "Completion received error. Ignoring completions."
        return
    fi

    local activeHelpMarker="_activeHelp_ "
    local endIndex=${#activeHelpMarker}
    local startIndex=$((${#activeHelpMarker}+1))
    local hasActiveHelp=0
    while IFS='\n' read -r comp; do
        # Check if this is an activeHelp statement (i.e., prefixed with $activeHelpMarker)
        if [ "${comp[1,$endIndex]}" = "$activeHelpMarker" ];then
            __invoice_debug "ActiveHelp found: $comp"
            comp="${comp[$startIndex,-1]}"
            if [ -n "$comp" ]; then
                compadd -x "${comp}"
                __invoice_debug "ActiveHelp will need delimiter"
                hasActiveHelp=1
            fi

            continue
        fi

        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab="$(printf '\t')"
            comp=${comp//$tab/:}

            __invoice_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    # Add a delimiter after the activeHelp statements, but only if:
    # - there are completions following the activeHelp statements, or
    # - file completion will be performed (so there will be choices after the activeHelp)
    if [ $hasActiveHelp -eq 1 ]; then
        if [ ${#completions} -ne 0 ] || [ $((directive & shellCompDirectiveNoFileComp)) -eq 0 ]; then
            __invoice_debug "Adding activeHelp delimiter"
            compadd -x "--"
            hasActiveHelp=0
        fi
    fi

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __invoice_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveKeepOrder)) -ne 0 ]; then
        __invoice_debug "Activating keep order."
        keepOrder="-V"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __invoice_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __invoice_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __invoice_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __invoice_debug "Calling _describe"
        if eval _describe $keepOrder "completions" completions $flagPrefix $noSpace; then
            __invoice_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __invoice_debug "_describe did not find completions."
            __invoice_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __invoice_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __invoice_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_invoice" ]; then
    _invoice
fi




# Run tmux if:
# - tmux is installed.
# - not already running.
# - shell is interactive.
# if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [[ $- = *i* ]]; then
#    # Always run tmux in base session.
#    tmux attach -t master || tmux new -s master
#    exit
# fi

# theme.sh
# if command -v theme.sh &> /dev/null; then
#   if [ -f "${XDG_RUNTIME_DIR}/shell/theme" ] ; then
#     theme.sh "$( cat "${XDG_RUNTIME_DIR}/shell/theme" )"
#   elif [ -f "${XDG_RUNTIME_DIR}/shell/background" ]; then
#     background="$( cat "${XDG_RUNTIME_DIR}/shell/background" )"
#     if [ "$background" = "light" ]; then
#       theme.sh "gruvbox-light-hard"
#     else
#       theme.sh "gruvbox-dark-hard"
#     fi
#   fi
# fi


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


# if [ -f "$XDG_RUNTIME_DIR/work_mode" ]; then
#   work_mode="$( cat "$XDG_RUNTIME_DIR/work_mode" )"
# else
#   work_mode="normal"
# fi

case "$work_mode" in
  audiebant) cd ~/Audiebant;;
esac


eval "$(starship init zsh)"
