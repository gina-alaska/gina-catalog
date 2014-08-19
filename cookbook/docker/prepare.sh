#!/bin/bash

yum update -y
yum install -y openssh-server sudo


mkdir -p /root/.ssh
chmod 700 /root/.ssh
chown root:root /root/.ssh
cp /build/insecure_key.pub /etc/insecure_key.pub
cp /build/insecure_key /etc/insecure_key
chmod 644 /etc/insecure_key*
chown root:root /etc/insecure_key*
cp /build/enable_insecure_key /usr/sbin/

/build/regen_ssh_host_keys.sh 
