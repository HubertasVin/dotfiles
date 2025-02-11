# Changing bash history size
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=''
# Changing default editor to nvim
export VISUAL=nvim
export EDITOR=nvim
export JAVA_HOME=/usr/lib/jvm/java-23-openjdk   # Set JAVA_HOME to fix mvn Java version error

# Setup PATHs
export PATH=$HOME/.npm-global/bin:$PATH:$HOME/.dotnet/tools:$HOME/go/bin

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

# Enable brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
