#!/bin/bash
set -u
: "$REMOTE_IP"
: "$RAKE_FILE"
: "$APP_NAME"

SECRET=$(rake -f "$RAKE_FILE" secret)

ssh root@$REMOTE_IP \
	dokku config:set --encoded $APP_NAME \
		SECRET_KEY_BASE=$SECRET
		
echo "Set secret: $SECRET"