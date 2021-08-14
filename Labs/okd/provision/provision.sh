#!/bin/bash

mkdir -p /root/.ssh
cp /vagrant/files/key.pub /root/.ssh/authorized_keys

HOSTS="$(head -n2 /etc/hosts)"
echo -e "$HOSTS" > /etc/hosts
cat >> /etc/hosts <<EOF
172.27.11.10 sanux-10.lab.com sanux-10
172.27.11.20 sanux-20.lab.com sanux-20

EOF

