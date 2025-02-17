setopt prompt_subst
# Bind Ctrl+Left and Ctrl+Right to move by word
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word
# Bind Ctrl+Backspace and Ctrl+Delete to delete whole word
bindkey "^H" backward-kill-word
bindkey "\e[3;5~" kill-word

bold_c=$(tput bold)
normal_c=$(tput sgr0)
input_start_colored="%{$(tput setaf 136)%}❯%{${normal_c}%}"

function preexec() {
    __start_time=$(date +%s%N)
}

function precmd() {
    if [[ -n "$__start_time" ]]; then
        local __end_time elapsed_ns elapsed_ms elapsed_sec threshold_ms
        __end_time=$(date +%s%N)
        elapsed_ns=$(( __end_time - __start_time ))
        elapsed_ms=$(( elapsed_ns / 1000000 ))
        if (( elapsed_ms > 4000 )); then
            elapsed_sec=$(awk "BEGIN {printf \"%.3f\", $elapsed_ns/1000000000}")
            print -P " %F{cyan}[Took ${elapsed_sec} seconds]%f"
        fi
        unset __start_time
    fi
}

function truncated_pwd() {
    local pwd_color="%{$(tput setaf 202)%}"
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local repo_root repo_name rel
        repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
        repo_name=$(basename "$repo_root")
        rel=${PWD#$repo_root}
        rel=${rel#/}
        if [ -n "$rel" ]; then
            echo "${pwd_color}${repo_name}/${rel}%{${normal_c}%}"
        else
            echo "${pwd_color}${repo_name}%{${normal_c}%}"
        fi
    else
        # If inside the home directory, replace $HOME with ~
        if [[ "$PWD" == "$HOME"* ]]; then
            echo "${pwd_color}~${PWD#$HOME}%{${normal_c}%}"
        else
            echo "${pwd_color}$PWD%{${normal_c}%}"
        fi
    fi
}

function vcs_super_info() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

        local git_numstat=$(git diff --numstat 2>/dev/null)
        local added=$(echo $git_numstat | awk '{added += $1} END {print added+0}')
        local deleted=$(echo $git_numstat | awk '{deleted += $2} END {print deleted+0}')

        local branch_colored="%{$(tput setaf 172)${bold_c}%}(${branch})%{${normal_c}%}"

        local added_colored deleted_colored
        [ "$added" -eq 0 ] && added_colored="" || added_colored="%{$(tput setaf 70)${bold_c}%}↑${added}%{${normal_c}%}"

        [ "$deleted" -eq 0 ] && deleted_colored="" || deleted_colored="%{$(tput setaf 124)${bold_c}%}↓${deleted}%{${normal_c}%}"

        echo "${branch_colored} ${added_colored} ${deleted_colored}"
    fi
}

PS1='$(truncated_pwd) $(vcs_super_info)
$input_start_colored '


#------------------------------------------------------------------------------
# History settings
#------------------------------------------------------------------------------
export HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY   # Add execution time for each command
setopt APPEND_HISTORY     # Append history to the file rather than overwriting it
setopt INC_APPEND_HISTORY # Save each command as it's entered
setopt SHARE_HISTORY      # Optionally, share history between multiple sessions

#------------------------------------------------------------------------------
# Default editors and JAVA_HOME
#------------------------------------------------------------------------------
export VISUAL=nvim
export EDITOR=nvim
export JAVA_HOME=/usr/bin/java   # Set JAVA_HOME to fix mvn Java version error

#------------------------------------------------------------------------------
# PATH setup
#------------------------------------------------------------------------------
export PATH="$HOME/.npm-global/bin:$PATH:$HOME/.dotnet/tools:$HOME/go/bin"

#------------------------------------------------------------------------------
# zsh Completion (similar to bash menu-complete)
#------------------------------------------------------------------------------
autoload -Uz compinit && compinit
# Enable menu selection when there are multiple completions
zstyle ':completion:*' menu select=2
# Enable zsh plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#------------------------------------------------------------------------------
# Aliases
#------------------------------------------------------------------------------
alias clr='clear'
alias sound_reload="systemctl --user restart pipewire.service"
alias sound_reset="systemctl --user unmask pulseaudio; systemctl --user --now disable pipewire.socket; systemctl --user --now enable pulseaudio.service pulseaudio.socket"
alias backupDevice="python ~/tools/backup/remote/backup-remote.py"
alias restoreDevice="python ~/tools/backup/remote/restore-remote.py"
alias xr144="xrandr --output DP-1 --mode 1920x1080 --rate 144"
alias prime-run="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia"
alias ..="cd .."
alias sshuosis="ssh -L 5555:linux:3389 huvi8958@uosis.mif.vu.lt"
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=$(cat $HOME/.rangerdir); cd "$LASTDIR"'

#------------------------------------------------------------------------------
# mkcd: Create directory and change into it
#------------------------------------------------------------------------------
mkcd() {
    if [ -d "$1" ]; then
        echo "Error: Directory '$1' already exists."
    else
        mkdir "$1" && cd "$1"
    fi
}

#------------------------------------------------------------------------------
# Load additional environment settings
#------------------------------------------------------------------------------
# Rust
source "$HOME/.cargo/env"

# SDKMAN (should be at the end)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

