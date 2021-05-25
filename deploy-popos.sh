#!/bin/sh

# Upgrade System
sudo apt-get update
sudo apt-get upgrade

# Install Basic System Tools
sudo apt-get -y install snapd vim

# Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt -y install ./google-chrome-stable_current_amd64.deb

# Install Core Software
sudo snap install spotify bitwarden onenote-desktop p3x-onenote odrive-unofficial discord

# Install Developer Tools
sudo snap install code --classic
sudo snap install postman

# GitHub Desktop
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

# Configure Git Identity
git config --global user.email "oscar@otbeaumont.me"
git config --global user.name "Oscar Beaumont"

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup default nightly
rustup default stable

# Go Lang
wget -O go.tar.gz https://golang.org/dl/go1.16.4.linux-amd64.tar.gz
tar -xvf go.tar.gz
sudo mv go /usr/local
rm -rf go.tar.gz
mkdir $GOPATH

# Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node
nvm install-latest-npm
npm i -g npm-check-updates serve netlify-cli

# Terminal
sudo apt-get -y install zsh fonts-powerline
sudo usermod -s /usr/bin/zsh $(whoami)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/denysdovhan/spaceship-prompt.git "~/.oh-my-zsh/custom/themes/spaceship-prompt" --depth=1
ln -s ~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Configure Firewall
sudo ufw enable
sudo ufw allow https
sudo ufw allow http
sudo ufw allow ssh

# TODO: Setup ~/.zshrc

# TODO: Setup SSH Keys
# ssh-keygen -t ed25519 -C "oscar@otbeaumont.me"