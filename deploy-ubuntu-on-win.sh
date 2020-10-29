#!/bin/bash
# Enable "Windows Subsystem for Linux" Feature
# Install "Ubuntu 20.04 LTS"

touch /home/oscar/.hushlogin
sudo apt-get update && sudo apt-get -y upgrade

# Basic Tools
sudo apt-get -y install build-essential

# Go Lang
wget -O go.tar.gz https://dl.google.com/go/go1.15.3.linux-amd64.tar.gz
tar -xvf go.tar.gz
sudo mv go /usr/local
rm -rf go.tar.gz

# ~/.bashrc & /root/.bashrc
    # Go Lang
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

mkdir $GOPATH

# SQLC
wget -O sqlc.tgz https://bin.equinox.io/c/jF3LhnJK5xn/sqlc-stable-linux-amd64.tgz
tar -xvf sqlc.tgz
sudo mv sqlc /usr/local/bin
rm -rf sqlc.tgz

# Nodejs
curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -
sudo apt-get install -y nodejs

# NPM Usefull Packages
sudo npm i -g npm-check-updates serve