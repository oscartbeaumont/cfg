#!/bin/sh

# Install Chrome from internet and DB Beaver from Software Store

# Upgrade System
sudo apt-get update
sudo apt-get upgrade

# Install Basic System Tools
sudo apt-get -y install vim git curl build-essential libssl-dev

# Install Non-snap Software
sudo apt-get install tilda baobab

# Install Core Software
sudo snap install spotify bitwarden onenote-desktop p3x-onenote caprine libreoffice # TODO: Chose OneNote client
sudo snap install slack --classic

# TODO: Install Discord as deb for better IPC support (used by Vscode presence feature)

# Install Developer Tools
sudo snap install code --classic
sudo snap install postman
sudo snap install --edge gh && snap connect gh:ssh-keys

# AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Configure Git Identity
git config --global user.email "oscar@otbeaumont.me"
git config --global user.name "Oscar Beaumont"

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup default nightly
rustup default stable

# Rust tools
cargo install cargo-watch
cargo install cargo-expand
cargo install sqlx-cli
cargo install cargo-outdated

# Go Lang
snap install --classic go
sudo snap install sqlc

# Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node
nvm install-latest-npm
npm i -g npm-check-updates serve netlify-cli yarn

# Flutter
sudo snap install flutter --classic
sudo snap install android-studio --classic
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop

# Docker
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

# Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Terminal -> This step is broken!
sudo apt-get -y install zsh fonts-powerline
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/denysdovhan/spaceship-prompt.git "~/.oh-my-zsh/custom/themes/spaceship-prompt" --depth=1
ln -s ~/.oh-my-zsh/themes/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Lego ACME Client
cat >/usr/local/bin/lego <<EOL
#!/bin/sh
docker run goacme/lego $@
EOL
chmod +x /usr/local/bin/lego

# Configure Firewall
sudo ufw enable
sudo ufw allow https
sudo ufw allow http
sudo ufw allow ssh

# Hide mounted drives from dock
dconf write /org/gnome/shell/extensions/dash-to-dock/show-mounts false

# Configure Nautilus Sidebar
# Comment out the unwanted bookmarks in ~/.config/user-dirs.dirs
echo "enabled=false" > ~/.config/user-dirs.conf

# Nautilus "Open in Code"
wget -qO- https://raw.githubusercontent.com/cra0zy/code-nautilus/master/install.sh | bash

# Remove Trash from Desktop
gsettings set org.gnome.shell.extensions.desktop-icons show-trash false
gsettings set org.gnome.shell.extensions.desktop-icons show-home false

# TODO: Setup ~/.zshrc
# TODO: Setup ~/.ssh/config

# Manual Create DropBox file share
# Manual Link Google Drive through Ubuntu Settings

# Manual login to Vscode to sync extensions and settings

# Manual Configure Dock
# - Chrome
# - File Manager
# - Terminal
# - Spotify
# - Discord

# Manual Configure Startup Applications
# - Discord - discord --start-minimized
# - Slack - slack -u
# - Tilda - tilda --hidden
# - Caprine - caprine

# Manual Setup SSH Keys
# ssh-keygen -t ed25519 -C "oscar@otbeaumont.me"
