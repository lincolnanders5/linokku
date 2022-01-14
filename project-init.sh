#!/bin/bash
sh ./linode-init.sh # LABEL, IMAGE, LINODE_IP

ssh root@$LINODE_IP \
	LD_APP_NAME=lacom LD_APP_DOMAIN=lincolnanders.com \
	'bash -s' < dokku-init.sh