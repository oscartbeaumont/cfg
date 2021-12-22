#!/bin/bash

# https://gist.github.com/ourownstory/728e5894b9b86d6b21579fd9ded4c30e
# Install Chrome from website directly

# sudo xset m 1 1

# Upgrade System
apt-get update
apt-get -y upgrade

# Install Basic System Tools
apt-get -y install htop vim git curl build-essential libssl-dev apt-transport-https ca-certificates wavemon tmux gparted snapd openssh-server gnupg2 scdaemon

# Install Non-snap Software
apt-get -y install tilda virtualbox

# Common Applications
flatpak install -y --noninteractive flathub com.spotify.Client
flatpak install -y --noninteractive flathub com.discordapp.Discord
flatpak install -y --noninteractive flathub com.sindresorhus.Caprine
flatpak install -y --noninteractive flathub com.bitwarden.desktop
flatpak install -y --noninteractive flathub com.todoist.Todoist
flatpak install -y --noninteractive flathub com.slack.Slack
flatpak install -y --noninteractive flathub md.obsidian.Obsidian
flatpak install -y --noninteractive flathub org.mozilla.Thunderbird
flatpak install -y --noninteractive flathub org.videolan.VLC

# Developer Tools
snap install code --classic
flatpak install -y --noninteractive flathub com.getpostman.Postman
flatpak install -y --noninteractive flathub io.dbeaver.DBeaverCommunity
snap install kubectl --classic
snap install go --classic
snap install docker
snap install sqlc

# Random Tools
flatpak install -y --noninteractive flathub org.nmap.Zenmap

# Syncthing
curl -s -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | tee /etc/apt/sources.list.d/syncthing.list
apt-get update
apt-get -y install syncthing
cp /usr/share/applications/syncthing-start.desktop ~/.config/autostart/syncthing-start.desktop

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup default nightly
rustup default stable

# Rust tools
cargo install cargo-watch cargo-edit cargo-expand cargo-outdated sqlx-cli cargo-license cargo-cache

# Node
curl https://get.volta.sh | bash
export PATH="$HOME/.volta/bin:$PATH"
volta install node@16
npm i -g npm-check-updates serve netlify-cli yarn typescript pnpm

# Flutter
snap install flutter --classic
snap install android-studio --classic
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop

# Java
apt-get -y install default-jdk

# Docker Permissions
addgroup --system docker
adduser $USER docker
newgrp docker
snap disable docker
snap enable docker

# Configure Firewall
ufw enable
ufw allow ssh

# Sound switcher
add-apt-repository -y ppa:yktooo/ppa
apt-get install -y indicator-sound-switcher

# Configure tilda to run on startup
mkdir -p ~/.config/autostart/
cat >~/.config/autostart/tilda.desktop <<EOL
[Desktop Entry]
Type=Application
Exec=tilda --hidden
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_AU]=Tilda
Name=Tilda
Comment[en_AU]=
Comment=
EOL
cp ./tilda_cfg ~/.config/tilda/config_0

# Configure SSH
mkdir -p ~/.ssh/
wget -O ~/.ssh/authorized_keys https://otbeaumont.me/keys
sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
service ssh restart

# Configure Git Identity
git config --global user.email "oscar@otbeaumont.me"
git config --global user.name "Oscar Beaumont"
git config --global init.defaultBranch main
git config --global gpg.program gpg2
git config --global commit.gpgsign true
git config --global user.signingkey 8F7C4F1C38B77ECB00C7B4389D9D7DA0E7A8E8D4

# Configure GPG
curl -sSL https://otbeaumont.me/gpg | gpg2 --import -
echo "enable-ssh-support" > ~/.gnupg/gpg-agent.conf

# Yubikey
apt-add-repository -y ppa:yubico/stable
apt-get update
apt-get -y install yubikey-manager

# Nautilus "Open in Code"
wget -qO- https://raw.githubusercontent.com/cra0zy/code-nautilus/master/install.sh | bash

# Install Playwright browsers
npx playwright install

# Expose Discord IPC socket from Flatpak
mkdir -p ~/.config/user-tmpfiles.d
echo 'L %t/discord-ipc-0 - - - - app/com.discordapp.Discord/discord-ipc-0' > ~/.config/user-tmpfiles.d/discord-rpc.conf
systemctl --user enable --now systemd-tmpfiles-setup.service

# Discord Startup
cat >~/.config/autostart/discord.desktop <<EOL
[Desktop Entry]
Type=Application
Exec=flatpak run com.discordapp.Discord --start-minimized
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_AU]=Discord
Name=Discord
Comment[en_AU]=
Comment=
EOL

# Slack Startup
cat >~/.config/autostart/slack.desktop <<EOL
[Desktop Entry]
Type=Application
Exec=flatpak run com.slack.Slack -u
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_AU]=Slack
Name=Slack
Comment[en_AU]=
Comment=
EOL

# Caprine Startup
cat >~/.config/autostart/caprine.desktop <<EOL
[Desktop Entry]
Type=Application
Exec=flatpak run com.sindresorhus.Caprine
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_AU]=Caprine
Name=Caprine
Comment[en_AU]=
Comment=
EOL

# Terminal
sudo apt-get -y install zsh fonts-powerline
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Facial Recognition Login
if [[ $(dmidecode -s system-product-name) = "XPS 13 9310 2-in-1" ]]; then
    add-apt-repository ppa:boltgolt/howdy
    apt-get -y install howdy # TODO: Has interactive prompt which will have to be fixed!
    
    git clone https://github.com/EmixamPP/linux-enable-ir-emitter.git
    cd linux-enable-ir-emitter
    sudo bash installer.sh install

    # TODO: https://github.com/boltgolt/howdy/issues/367
fi

# Configure non-root port
sysctl net.ipv4.ip_unprivileged_port_start=443

# Configure Nautilus Sidebar
echo "enabled=false" > ~/.config/user-dirs.conf # Prevents file being overriden

# Shutter
add-apt-repository -y ppa:shutter/ppa
apt-get -y install shutter

# Ktunnel (My custom fork)
git clone https://github.com/oscartbeaumont/ktunnel.git ktunnel
cd ktunnel/
CGO_ENABLED=0 go build -ldflags="-s -w"
mv ./ktunnel /usr/local/bin/ktunnel
cd ..
rm -rf ktunnel

# Allow Spotify to access my Soundcloud downloads
flatpak override --user --filesystem=~/Documents/OTBShared/files/Soundcloud:ro com.spotify.Client

# Configure SWAP
sudo fallocate -l 8G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

# TODO: Manual process
# - Manually login to Vscode to sync extensions and settings
# - Login to installed applications for accounts (Chrome, Spotify, Bitwarden)
# - Comment out the unwanted bookmarks in ~/.config/user-dirs.dirs
# - Configure Syncthing
# - Setup Frametag email in Thunderbird
# - Run `sudo linux-enable-ir-emitter configure` and `sudo howdy add`
# - Run `OTBShared/cfg/apply.sh`