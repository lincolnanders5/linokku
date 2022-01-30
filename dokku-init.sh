#!/bin/bash
: "$LC_APP_NAME"
: "$LC_APP_DOMAIN"

export DOKKU_TAG='v0.26.6'

# From:
# https://dokku.com/docs/getting-started/installation/
# https://dokku.com/docs/deployment/application-deployment/

cd /tmp
if [ -f "/tmp/bootstrap.sh" ]; then
	echo "---> init: Dokku already installed, skipping install."
else
	apt update -y
	wget "https://raw.githubusercontent.com/dokku/dokku/$DOKKU_TAG/bootstrap.sh"
	bash bootstrap.sh
fi

cat ~/.ssh/authorized_keys | dokku ssh-keys:add admin

dokku apps:create $LC_APP_DOMAIN && \
	echo "Created app '$LC_APP_DOMAIN'"
dokku domains:set $LC_APP_NAME $LC_APP_DOMAIN && \
	echo "Set domain '$LC_APP_DOMAIN' for '$LC_APP_NAME'"

if [ -z "${LC_CREATE_DB}" ]; then
	HAS_PLUGIN=$(dokku plugin:list | grep postgres | wc -l)
	if [[ $HAS_PLUGIN == 0 ]]; then
		dokku plugin:install https://github.com/dokku/dokku-postgres.git
	fi
	
	LC_DB_NAME="${LC_DB_NAME:-${LC_APP_NAME:-default}}_db"
	[[ $LC_APP_NAME == *"."* ]] && LC_DB_NAME=$(echo $LC_APP_NAME | cut -d. -f1)
	
	dokku postgres:create $LC_DB_NAME
	dokku postgres:link $LC_DB_NAME $LC_APP_NAME
	echo "---> init: created database '$LC_DB_NAME' connected to '$LC_APP_NAME'"
fi

if [ -z "${LC_CERT_EMAIL}" ]; then
	dokku certs:add $LC_APP_NAME server.crt server.key
	
	HAS_PLUGIN=$(dokku plugin:list | grep postgres | wc -l)
	if [[ $HAS_PLUGIN == 0 ]]; then
		dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
	fi
	
	echo $LC_CERT_EMAIL
	
	dokku config:set --global DOKKU_LETSENCRYPT_EMAIL="${LC_CERT_EMAIL}"
	dokku letsencrypt:enable $LC_APP_NAME
	dokku letsencrypt:cron-job --add
	echo "---> init: added https to '$LC_APP_NAME' registered to $LC_CERT_EMAIL"
fi