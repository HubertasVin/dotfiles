# Changing bash history size
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=''
# Changing default editor to nvim
export VISUAL=nvim
export EDITOR=nvim
export JAVA_HOME=/usr/lib/jvm/java-23-openjdk   # Set JAVA_HOME to fix mvn Java version error

# Setup PATHs
export PATH=~/.npm-global/bin:$PATH
export PATH=$PATH:~/go/bin

export HISTCONTROL=  # Ensure no overwrites of historical entries

# Configure bash auto-completion
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# Add variables
INSTSCRIPT=/home/hubertas/Installation_Script

# Set the aliases
alias rm='rm -i'
alias clr='clear'
alias qtile_conf="cd ~/.config/qtile"
alias qtile_log="cd ~/.local/share/qtile"
alias sound_reload="systemctl --user restart pipewire.service"
alias sound_reset="systemctl --user unmask pulseaudio; systemctl --user --now disable pipewire.socket; systemctl --user --now enable pulseaudio.service pulseaudio.socket"
alias backupDevice="python ~/tools/backup/remote/backup-remote.py"
alias restoreDevice="python ~/tools/backup/remote/restore-remote.py"
alias xr144="xrandr --output DP-1 --mode 1920x1080 --rate 144"
alias prime-run="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia"
alias ..="cd .."
alias sshopi="ssh orangepi@10.15.5.176"
alias sshuosis="ssh -L 5555:linux:3389 huvi8958@uosis.mif.vu.lt"
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

# Create new directory and change the current directory to it
mkcd() {
    if [ -d "$1" ]; then
        echo "Error: Directory '$1' already exists."
    else
        mkdir "$1" && cd "$1"
    fi
}

# Set Ghcup environment variables
[ -f "/home/hubertas/.ghcup/env" ] && source "/home/hubertas/.ghcup/env"
# Set Rust environment variables
. "$HOME/.cargo/env"
# Start Sdkman (this must be at the end)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Start ble.sh
source ~/.local/share/blesh/ble.sh
export BASH_IT="/home/hubertas/.bash_it"  # Path to the bash it configuration
export BASH_IT_THEME='hubertas'           # Lock and Load a custom theme file
unset MAILCHECK                           # Don't check mail when opening terminal
bleopt history_lazyload=0
bleopt history_share=                     # Ensures the history file is not truncated when cancelling a selection
# Custom error and elapsed messages
bleopt exec_elapsed_mark=$'\e[94m[bash: elapsed %s (CPU %s%%)]\e[m'
bleopt exec_errexit_mark=$'\e[91m[bash: exit %d]\e[m'
bleopt exec_exit_mark=$'\e[94m[bash: exit]\e[m'
export SCM_CHECK=true                     # Set this to false to turn off version control status checking within the prompt for all themes
# Setup function that resets history location to the end after ctrl+c
function ble/widget/ctrl-c-reset-history {
    ble/widget/history-end                # Moves history pointer to the most recent entry
    ble/widget/discard-line               # Cancel the current input and start a new line
    # ble-edit/content/reset               # Cancel the current input
}

# Bind Ctrl+C to the custom function
ble-bind -f 'C-c' ctrl-c-reset-history    # Reset the Ctrl+c bind
source "$BASH_IT"/bash_it.sh              # Load Bash It

# Enable brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
