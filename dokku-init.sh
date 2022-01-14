#!/bin/bash
set -u
: "$LD_APP_NAME"
: "$LD_APP_DOMAIN"

# From:
# https://dokku.com/docs/getting-started/installation/
# https://dokku.com/docs/deployment/application-deployment/

apt update -y

cd /tmp
wget https://raw.githubusercontent.com/dokku/dokku/v0.26.6/bootstrap.sh
DOKKU_TAG=v0.26.6 bash bootstrap.sh
cat ~/.ssh/authorized_keys | dokku ssh-keys:add admin

dokku domains:set-global $LD_APP_DOMAIN

dokku apps:create $LD_APP_NAME && echo "Created app '$LD_APP_NAME'"

if [[ -z "${LD_DB_NAME}" ]]; then
	dokku plugin:install https://github.com/dokku/dokku-postgres.git
	dokku postgres:create $LD_DB_NAME
	dokku postgres:link $LD_DB_NAME $LD_APP_NAME
fi

if [[ -z "${LD_LETSENCRYPT_EMAIL}"]]; then
	dokku certs:add $LD_APP_NAME server.crt server.key
	dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
	dokku config:set --global DOKKU_LETSENCRYPT_EMAIL=$LD_LETSENCRYPT_EMAIL
	dokku domains:set $LD_APP_NAME $LD_APP_DOMAIN
	dokku letsencrypt:enable $LD_APP_NAME
	dokku letsencrypt:cron-job --add
fi