#!/bin/bash
set -e
if [[ ! -e /etc/ssh/ssh_host_dsa_key ]]; then
echo "No SSH host key available. Generating one..."
/usr/bin/ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
fi

if [[ ! -e /etc/ssh/ssh_host_rsa_key ]]; then
echo "No SSH host key available. Generating one..."
/usr/bin/ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
fi

