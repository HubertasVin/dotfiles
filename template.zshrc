setopt extended_glob
setopt prompt_subst


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

# Characters not considered part of words for word splitting
WORDCHARS=${WORDCHARS//[\/;,_=\-]/}

# Time reporting for all commands that took more than 3s
REPORTTIME=3
TIMEFMT=$' '"${CYAN}"'[Took %E; Avg CPU: %P]'${RESET}

# ---- Various exports ----
export VISUAL=nvim
export EDITOR=nvim
# PATH setup
export PATH="$HOME/.npm-global/bin:$PATH:$HOME/.dotnet/tools:$HOME/go/bin"
# Set JAVA_HOME to fix mvn Java version error
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
# Custom cursor
export XCURSOR_THEME=Quintom_Ink


#NOTE: ------------------------------------------------------------------------------
#       Bindings
#      ------------------------------------------------------------------------------

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
# Bind the up and down arrow keys to search through history with typed context
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward


#NOTE: ------------------------------------------------------------------------------
#       Helper functions
#      ------------------------------------------------------------------------------

# Better word detection for killing words
function custom-backward-kill-word() {
    if [[ -z "$LBUFFER" ]]; then
        return 0
    fi

    if [[ "${LBUFFER: -1}" =~ [[:alnum:]] ]]; then
        LBUFFER=${LBUFFER/%([[:alnum:]]#)/}
    else
        LBUFFER=${LBUFFER/%([^[:alnum:]]#)/}
    fi
    zle reset-prompt
}
zle -N custom-backward-kill-word

function custom-forward-kill-word() {
    if [[ -z "$RBUFFER" ]]; then
        return 0
    fi

    if [[ "${RBUFFER:0:1}" =~ [[:alnum:]] ]]; then
        RBUFFER=${RBUFFER/#([[:alnum:]]#)/}
    else
        RBUFFER=${RBUFFER/#([^[:alnum:]]#)/}
    fi
    zle reset-prompt
}
zle -N custom-forward-kill-word

# Custom widget for moving the cursor left (Ctrl+Left)
function custom-backward-word() {
    if [[ -z "$LBUFFER" ]]; then
        return 0
    fi

    local word
    if [[ "${LBUFFER: -1}" =~ [[:alnum:]] ]]; then
        word=${LBUFFER##*[^[:alnum:]]}
    else
        word=${LBUFFER##*([[:alnum:]])}
    fi
    LBUFFER=${LBUFFER%$word}
    RBUFFER="$word$RBUFFER"
    zle reset-prompt
}
zle -N custom-backward-word

# Custom widget for moving the cursor right (Ctrl+Right)
function custom-forward-word() {
    if [[ -z "$RBUFFER" ]]; then
        return 0
    fi

    local word
    if [[ "${RBUFFER:0:1}" =~ [[:alnum:]] ]]; then
        word=${RBUFFER%%[^[:alnum:]]*}
    else
        word=${RBUFFER%%[[:alnum:]]*}
    fi
    LBUFFER=$LBUFFER$word
    RBUFFER=${RBUFFER#$word}
    zle reset-prompt
}
zle -N custom-forward-word


#NOTE: ------------------------------------------------------------------------------
#       Prompt creation
#      ------------------------------------------------------------------------------

input_start_colored="%{$(tput setaf 136)%}❯%{${RESET}%}"

function truncated_pwd() {
    local pwd_color="%{$(tput setaf 202)%}"
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local repo_root repo_name rel
        repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
        repo_name=$(basename "$repo_root")
        rel=${PWD#$repo_root}
        rel=${rel#/}
        if [ -n "$rel" ]; then
            echo "${pwd_color}${repo_name}/${rel}%{${RESET}%}"
        else
            echo "${pwd_color}${repo_name}%{${RESET}%}"
        fi
    else
        # If inside the home directory, replace $HOME with ~
        if [[ "$PWD" == "$HOME"* ]]; then
            echo "${pwd_color}~${PWD#$HOME}%{${RESET}%}"
        else
            echo "${pwd_color}$PWD%{${RESET}%}"
        fi
    fi
}

function vcs_super_info() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

        local git_numstat=$(git diff --numstat 2>/dev/null)
        local added=$(echo $git_numstat | awk '{added += $1} END {print added+0}')
        local deleted=$(echo $git_numstat | awk '{deleted += $2} END {print deleted+0}')

        local branch_colored="%{$(tput setaf 172)${BOLD}%}(${branch})%{${RESET}%}"

        local added_colored deleted_colored
        [ "$added" -eq 0 ] && added_colored="" || added_colored="%{$(tput setaf 70)${BOLD}%}↑${added}%{${RESET}%}"

        [ "$deleted" -eq 0 ] && deleted_colored="" || deleted_colored="%{$(tput setaf 124)${BOLD}%}↓${deleted}%{${RESET}%}"

        echo "${branch_colored} ${added_colored} ${deleted_colored}"
    fi
}

PS1='$(truncated_pwd) $(vcs_super_info)
$input_start_colored '


#NOTE: ------------------------------------------------------------------------------
#       History settings
#      ------------------------------------------------------------------------------

export HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY   # Add execution time for each command
setopt APPEND_HISTORY     # Append history to the file rather than overwriting it
setopt INC_APPEND_HISTORY # Save each command as it's entered
setopt SHARE_HISTORY      # Optionally, share history between multiple sessions

#NOTE: ------------------------------------------------------------------------------
#       ZSH Completion
#      ------------------------------------------------------------------------------

autoload -Uz compinit && compinit
# Enable menu selection when there are multiple completions
zstyle ':completion:*' menu select=2
# Enable zsh plugins
source $(/home/linuxbrew/.linuxbrew/bin/brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(/home/linuxbrew/.linuxbrew/bin/brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#NOTE: ------------------------------------------------------------------------------
#       Aliases
#      ------------------------------------------------------------------------------

alias clr='clear'
alias sound_reload="systemctl --user restart pipewire.service"
alias sound_reset="systemctl --user unmask pulseaudio; systemctl --user --now disable pipewire.socket; systemctl --user --now enable pulseaudio.service pulseaudio.socket"
alias backupDevice="python ~/tools/backup/remote/backup-remote.py"
alias restoreDevice="python ~/tools/backup/remote/restore-remote.py"
alias xr144="xrandr --output DP-1 --mode 1920x1080 --rate 144"
alias prime-run="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia"
alias ..="cd .."
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=$(cat $HOME/.rangerdir); cd "$LASTDIR"'
alias sshvps="ssh hubserv@198.7.118.97"

#NOTE: ------------------------------------------------------------------------------
#       mkcd: Create directory and change into it
#      ------------------------------------------------------------------------------

mkcd() {
    if [ -d "$1" ]; then
        echo "Error: Directory '$1' already exists."
    else
        mkdir "$1" && cd "$1"
    fi
}

#NOTE: ------------------------------------------------------------------------------
#       Load additional environment settings
#      ------------------------------------------------------------------------------

# Rust
source "$HOME/.cargo/env"

# SDKMAN (should be at the end)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
