#!/bin/sh

# Cirrus
# TODO: Fill missing stuff here
dokku letsencrypt cirrus

# Dev Proxy
dokku apps:create dev-proxy
dokku domains:set dev-proxy dev.otbeaumont.me
git remote add dokku dokku@cirrus:dev-proxy
git push dokku master
dokku letsencrypt dev-proxy

# Dev Proxy2
dokku apps:create dev-proxy2
dokku domains:set dev-proxy2 dev2.otbeaumont.me
git remote add dokku dokku@cirrus:dev-proxy2
git push dokku master
dokku letsencrypt dev-proxy2