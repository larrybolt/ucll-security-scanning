#!/usr/bin/env bash

# Get the public ip address for this network
PUBLIC_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
echo "PUBLIC IP: $PUBLIC_IP"

# Get local ip addresses
# Probably the first is the one we want, but scan all for good measure
LOCAL_IPS=$(ifconfig \
	| grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' \
	| grep -Eo '([0-9]*\.){3}[0-9]*' \
	| grep -v '127.0.0.1') # exclude loopback

for IP in $LOCAL_IPS; do
	echo "Scanning IP: $IP"
done
