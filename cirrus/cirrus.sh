#
# This is the script to deploy Cirrus my primary cloud server
# cirrus.otbeaumont.me
#

# On My Systems: ssh-keygen -t rsa -b 4096 -C "oscar@OSCARS-XPS-13"

# Create Security Group + Instance + Elastic IP
# AWS Notes: Firewall handled by security group, Automatic Updates on by default

# Updates
apt-get update && apt-get -y upgrade

# Setup secondary network interface
sudo nano /etc/netplan/51-eth1.yaml
    network:
    ethernets:
        eth1:
            dhcp4: true
            dhcp6: false
            match:
                macaddress: {todo_put_mac_address_here}
            set-name: eth1
    version: 2
sudo netplan --debug apply

# Custom User
adduser oscar
adduser oscar sudo
mkdir /home/oscar/.ssh
nano /home/oscar/.ssh/authorized_keys

# SSH
nano /etc/ssh/sshd_config
    Port 2222
    PermitRootLogin no
    PasswordAuthentication no
    PermitEmptyPasswords no
    GatewayPorts clientspecified
/etc/init.d/ssh restart

apt-get install -y fail2ban
nano /etc/fail2ban/jail.local
    [sshd]
    enabled = true
    port = 2222
    filter = sshd
    logpath = /var/log/auth.log
    maxretry = 3
    findtime = 300
    bantime = 3600
    ignoreip = 127.0.0.1
/etc/init.d/fail2ban start

# Set Hostname
hostnamectl set-hostname cirrus

# Dokku
wget https://raw.githubusercontent.com/dokku/dokku/v0.22.5/bootstrap.sh
sudo DOKKU_TAG=v0.22.5 bash bootstrap.sh

# Dokku Letsencrypt
sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
dokku config:set --global DOKKU_LETSENCRYPT_EMAIL=oscar@otbeaumont.me

# Dokku Postgres
dokku plugin:install https://github.com/dokku/dokku-postgres.git

# Dokku Generate CI Credentials
#   ssh-keygen -f pokebot -t rsa -b 4096 -C "pokebot@github-actions"
#   dokku ssh-keys:add pokebot pokebot.pub

# Reboot
reboot

# Remove ubuntu user
deluser --remove-home ubuntu