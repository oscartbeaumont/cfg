# Oh My Zsh
export ZSH="/home/oscar/.oh-my-zsh"
ZSH_THEME="spaceship"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting nvm)
source $ZSH/oh-my-zsh.sh

# User configuration
export LANG=en_US.UTF-8
export EDITOR='nano'

# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Yubikey
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent