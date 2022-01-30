#!/bin/bash
SSH_FILE="${SSH_FILE:-~/.ssh/id_rsa.pub}"
SSH_DATA=$(cat $SSH_FILE)

SERVER=$(linode-cli linodes create --authorized_keys "$SSH_DATA" --root_pass | head -4 | tail -1)

export LABEL=$(echo $SERVER | cut -d" " -f 4)
export IMAGE=$(echo $SERVER | cut -d" " -f 10)
export REMOTE_IP=$(echo $SERVER | cut -d" " -f 14)
STATUS=$(echo $SERVER | cut -d" " -f 12)

if [[ $STATUS == *"provisioning"* ]]; then
	echo "Created server ${LABEL} [${IMAGE}] @ ${REMOTE_IP}"
else
	echo "Could not provision server ($STATUS). Exiting." 
	exit 1
fi