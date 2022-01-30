#!/bin/bash
set -u
: "$LC_APP_DOMAIN"
: "$LC_APP_NAME"

set +u

export LC_CERT_EMAIL="${LC_CERT_EMAIL:-}"

if [[ -z "${REMOTE_IP}" ]]; then
	source linode-init.sh # LABEL, IMAGE, REMOTE_IP
fi

ssh -o ConnectTimeout=1800 root@$REMOTE_IP 'bash -s' < dokku-init.sh