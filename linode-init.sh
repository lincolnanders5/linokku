#!/bin/bash
SERVER=$(linode-cli linodes create --root_pass | head -4 | tail -1)
export LABEL=$(echo $SERVER | cut -d" " -f 4)
export IMAGE=$(echo $SERVER | cut -d" " -f 10)
export LINODE_IP=$(echo $SERVER | cut -d" " -f 14)
STATUS=$(echo $SERVER | cut -d" " -f 16)

[ "${STATUS}" != "provisioning" ] && \
	echo "Could not provision server. Exiting." && \
	exit

echo "Created server ${LABEL} [${IMAGE}] @ ${LINODE_IP}"