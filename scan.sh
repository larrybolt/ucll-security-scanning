#!/usr/bin/env bash
source ./common.sh
#::netmask2cidr

# Get the public ip address for this network
PUBLIC_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
echo "PUBLIC IP: $PUBLIC_IP"

# Get local ip addresses
# Probably the first is the one we want, but scan all for good measure
LOCAL_IPS=$(ifconfig \
	| grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]{1,3} netmask (0x[0-f]{8})' \
	| grep -Eo '([0-9]*\.){3}[0-9].*(0x[0-f]{8})' \
	| grep -v '127.0.0.1')

IFS=$'\n'
for _IP in $LOCAL_IPS; do
	IP="$(echo $_IP | cut -d' ' -f1)"
	NETMASK="$(echo $_IP | cut -d' ' -f3)"
	CIDR="$(::netmask2cidr $NETMASK)"

	echo "Scanning IP: $IP/$CIDR"
done
