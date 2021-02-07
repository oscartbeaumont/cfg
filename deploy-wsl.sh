#!/bin/env sh

# TODO: Make this automatic

# Housekeeping
touch /home/oscar/.hushlogin
sudo apt-get update && sudo apt-get -y upgrade

# Configure Terminal
sudo apt-get -y install zsh fonts-powerline
sudo usermod -s /usr/bin/zsh $(whoami)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/denysdovhan/spaceship-prompt.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt" --depth=1
ln -s "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/../themes/spaceship.zsh-theme" 
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Basic Tools
sudo apt-get -y install build-essential python3-pip

# Go Lang
wget -O go.tar.gz https://dl.google.com/go/go1.15.3.linux-amd64.tar.gz
tar -xvf go.tar.gz
sudo mv go /usr/local
rm -rf go.tar.gz
mkdir $GOPATH

# SQLC
wget -O sqlc.tgz https://bin.equinox.io/c/jF3LhnJK5xn/sqlc-stable-linux-amd64.tgz
tar -xvf sqlc.tgz
sudo mv sqlc /usr/local/bin
rm -rf sqlc.tgz

# Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
nvm install node
nvm install-latest-npm
npm i -g npm-check-updates serve

# Electron libraries
sudo apt-get -y install libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev

# XServer
# TODO: Follow https://www.beekeeperstudio.io/blog/building-electron-windows-ubuntu-wsl2

# Postgres and PGAdmin
curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
sudo apt-get -y install postgresql pgadmin4
sudo /usr/pgadmin4/bin/setup-web.sh # TODO: User interaction required

cat > /usr/bin/pq-start << EOL
#!/bin/sh
sudo /etc/init.d/postgresql start
sudo /etc/init.d/apache2 start
EOL
chmod +x /usr/bin/pq-start

# sudo /etc/init.d/apache2 start
# sudo nano /etc/apache2/ports.conf
#     Change Listen to 8005

# sudo -u postgres psql postgres
#     ALTER USER postgres WITH PASSWORD '{REPLACE_ME}';

#     CREATE USER mattrax_db;
#     ALTER USER mattrax_db WITH SUPERUSER;
#     ALTER USER mattrax_db WITH PASSWORD '{REPLACE_ME}';

#     \quit

# Allow nonroot users to bind to privileged ports
sudo sysctl -w net.ipv4.ip_unprivileged_port_start=0

######################################################
###################### Optional ######################
######################################################

# Work Environment -> Google Cloud Functions Yarn Monorepo
sudo apt-get -y install default-jre # This is needed by Firestore Emulator
nvm install 12.18.4
nvm use 12.18.4
npm install -g yarn firebase-tools
firebase login
