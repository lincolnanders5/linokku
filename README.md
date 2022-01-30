# Linode Deploy
A series of scripts for deploying projects to Linode servers.

```shell
# in linode-deploy repo
export LC_APP_NAME=
export LC_APP_DOMAIN=
export SSH_FILE=~/.ssh/id_rsa.pub
./project-init.sh
# ... deployed to REMOTE_IP


# in a deployable repo
export REMOTE_IP=
git remote set-url dokku dokku@$REMOTE_IP:$LC_APP_DOMAIN
git push dokku main:master

# setup secret key
RAKE_FILE=~/path/to/Rakefile ./secret-share.sh

# From Remote Host: ssh root@$REMOTE_IP 
## compile assets
dokku run $LC_APP_DOMAIN compile

## set app.json
dokku app-json:set $LC_APP_NAME appjson-path app.json

## expose port
dokku proxy:ports-set $LC_APP_NAME http:80:3000
```
