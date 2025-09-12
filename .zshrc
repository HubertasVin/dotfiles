#NOTE: ------------------------------------------------------------------------------
#       Variables
#      ------------------------------------------------------------------------------

# ---- Colors ----
# Define foreground colors
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
# You can also define background colors if needed:
BG_BLACK=$(tput setab 0)
BG_RED=$(tput setab 1)
BG_GREEN=$(tput setab 2)
BG_YELLOW=$(tput setab 3)
BG_BLUE=$(tput setab 4)
BG_MAGENTA=$(tput setab 5)
BG_CYAN=$(tput setab 6)
BG_WHITE=$(tput setab 7)
# Special colors
BOLD=$(tput bold)
RESET=$(tput sgr0)
# History variables
HISTSIZE=10000
SAVEHIST=10000
HISTDUP=erase
# Syntax highlighting options
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
# Characters not considered part of words for word splitting
WORDCHARS=${WORDCHARS//[\/;,_=\-]/}
# Time reporting for all commands that took more than 3s
REPORTTIME=3
TIMEFMT=$' '"${CYAN}"'[Took %E; Avg CPU: %P]'${RESET}

# ---- Various exports ----
export VISUAL=nvim
export EDITOR=nvim
# PATH setup
export PATH="$HOME/.npm-global/bin:$PATH:$HOME/.dotnet/tools:$HOME/go/bin:$HOME/.local/bin"
# Set JAVA_HOME to fix mvn Java version error
export JAVA_HOME=/usr/lib/jvm/temurin-17-jdk
# Custom cursor
export XCURSOR_THEME=Quintom_Ink
# History file
export HISTFILE="$HOME/.zsh_history"


#NOTE: ------------------------------------------------------------------------------
#       Bindings
#      ------------------------------------------------------------------------------

function rebind-ctrl-arrows() {
    # Bind Ctrl+Left and Ctrl+Right to move by word
    bindkey "\e[1;5D" custom-backward-word
    bindkey "\e[1;5C" custom-forward-word
    # Bind Home and End to move to line start or end
    bindkey "\e[1~" beginning-of-line
    bindkey "\e[4~" end-of-line
    # Character / word delete
    bindkey '^H' custom-backward-kill-word
    bindkey "\e[3;5~" custom-forward-kill-word
    bindkey "\e[3~" delete-char
}
# Bind the up and down arrow keys to search through history with typed context
bindkey '\e[A' history-beginning-search-backward-end
bindkey '\e[B' history-beginning-search-forward-end
# Newline bind Ctrl+j
bindkey '^J' self-insert


#NOTE: ------------------------------------------------------------------------------
#       Settings
#      ------------------------------------------------------------------------------

setopt appendhistory
# setopt SHARE_HISTORY      # Optionally, share history between multiple sessions
setopt extended_glob
setopt prompt_subst
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
# Save history, but don't share it between sessions
setopt inc_append_history_time
setopt hist_fcntl_lock
setopt hist_save_by_copy
setopt extended_history

autoload -Uz compinit && compinit

zle -N zle-line-init rebind-ctrl-arrows
zle -N zle-keymap-select rebind-ctrl-arrows

autoload -Uz history-search-end

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end


#NOTE: ------------------------------------------------------------------------------
#       Zinit setup
#      ------------------------------------------------------------------------------

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load zinit
source "${ZINIT_HOME}/zinit.zsh"


#NOTE: ------------------------------------------------------------------------------
#       ZSH Extensions
#      ------------------------------------------------------------------------------

# Add ZSH plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab

# Add snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found
# Disable esc unnecessary mappings
bindkey -M emacs '\e^M' accept-line
bindkey -M vicmd '\e^M' accept-line

zinit cdreplay -q

# Completion enhancements
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


#NOTE: ------------------------------------------------------------------------------
#       Aliases
#      ------------------------------------------------------------------------------

alias clr="clear"
alias gadd="git add -A"
alias gcommit="git commit -a"
alias gpush="git push origin -u @"
alias backupDevice="~/tools/backup/borg-backup.sh"
alias restoreDevice="~/tools/backup/borg-restore.sh"
alias xr144="xrandr --output DP-1 --mode 1920x1080 --rate 144"
alias prime-run="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia"
alias ..="cd .."
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=$(cat $HOME/.rangerdir); cd $LASTDIR'
alias sshvps="ssh hubserv@198.7.118.97"


#NOTE: ------------------------------------------------------------------------------
#       Custom QoL functions
#      ------------------------------------------------------------------------------

mkcd() {
    if [ -d "$1" ]; then
        echo "Error: Directory '$1' already exists."
    else
        mkdir "$1" && cd "$1"
    fi
}

bman() {
    local pattern args=()
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p)          pattern=$2; shift 2 ;;
            -p*)         pattern=${1#-p}; shift ;;
            *)           args+=("$1"); shift ;;
        esac
    done

    if [[ -n $pattern ]]; then
        command man -P "less -p '$pattern'" "${args[@]}"
    else
        command man "${args[@]}"
    fi
}

fcat() {
    local maxdepth="" pattern width find_args file prefix plen dash_count dashes

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d|--depth)
                maxdepth="$2"
                shift 2
                ;;
            -*)
                echo "Usage: find_and_cat [-d N] REGEX" >&2
                return 1
                ;;
            *)
                pattern="$1"
                shift
                ;;
        esac
    done

    if [[ -z "$pattern" ]]; then
        echo "Usage: find_and_cat [-d N] REGEX" >&2
        return 1
    fi

    # terminal width
    width=$(tput cols)

    # build find args
    find_args=(.)
    [[ -n "$maxdepth" ]] && find_args+=( -maxdepth "$maxdepth" )
    find_args+=( -regextype posix-extended -regex ".*$pattern" -type f )

    # run find and process
    while IFS= read -r file; do
        prefix="---- $file "
        plen=${#prefix}
        dash_count=$(( width > plen ? width - plen : 0 ))
        dashes=$(printf '%*s' "$dash_count" '' | tr ' ' '-')
        printf '%s%s\n' "$prefix" "$dashes"
        cat "$file"
    done < <(find "${find_args[@]}")
}


#NOTE: ------------------------------------------------------------------------------
#       Load additional environment settings
#      ------------------------------------------------------------------------------

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# Oh-my-posh prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh.toml)"

# Completion enhancements
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"


#NOTE: ------------------------------------------------------------------------------
#       Helper functions for binds
#      ------------------------------------------------------------------------------

# Helper functions for binds
function custom-backward-kill-word() {
    [[ -z "$LBUFFER" ]] && return 0
    if [[ "${LBUFFER: -1}" =~ [[:alnum:]] ]]; then
        LBUFFER=${LBUFFER/%([[:alnum:]]#)/}
    else
        LBUFFER=${LBUFFER/%([^[:alnum:]]#)/}
    fi
    zle -R
}
zle -N custom-backward-kill-word

function custom-forward-kill-word() {
    [[ -z "$RBUFFER" ]] && return 0
    if [[ "${RBUFFER:0:1}" =~ [[:alnum:]] ]]; then
        RBUFFER=${RBUFFER/#([[:alnum:]]#)/}
    else
        RBUFFER=${RBUFFER/#([^[:alnum:]]#)/}
    fi
    zle -R
}
zle -N custom-forward-kill-word

# Custom widget for moving the cursor left (Ctrl+Left)
function custom-backward-word() {
    [[ -z "$LBUFFER" ]] && return 0
    local word
    if [[ "${LBUFFER: -1}" =~ [[:alnum:]] ]]; then
        word=${LBUFFER##*[^[:alnum:]]}
    else
        word=${LBUFFER##*([[:alnum:]])}
    fi
    LBUFFER=${LBUFFER%$word}
    RBUFFER="$word$RBUFFER"
    zle -R
}
zle -N custom-backward-word

# Custom widget for moving the cursor right (Ctrl+Right)
function custom-forward-word() {
    [[ -z "$RBUFFER" ]] && return 0
    local word
    if [[ "${RBUFFER:0:1}" =~ [[:alnum:]] ]]; then
        word=${RBUFFER%%[^[:alnum:]]*}
    else
        word=${RBUFFER%%[[:alnum:]]*}
    fi
    LBUFFER+=$word
    RBUFFER=${RBUFFER#$word}
    zle -R
}
zle -N custom-forward-word
