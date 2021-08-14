#!/bin/bash

swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

mkdir -p /root/.ssh
cp /vagrant/files/key.pub /root/.ssh/authorized_keys

HOSTS="$(head -n2 /etc/hosts)"
echo -e "$HOSTS" > /etc/hosts
cat >> /etc/hosts <<EOF
172.27.11.110 sanux-lab-01.pt.com sanux-lab-01
172.27.11.120 sanux-lab-02.pt.com sanux-lab-02
EOF