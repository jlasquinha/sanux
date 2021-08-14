#!/bin/bash

# SWAP

swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Kernel Modules
touch /etc/modules-load.d/k8s.conf

MODK8S="$(head -n1 /etc/modules-load.d/k8s.conf)"
echo -e "$MODK8S" > /etc/modules-load.d/k8s.conf
cat >> /etc/modules-load.d/k8s.conf <<EOF
br_netfilter
ip_vs
ip_vs_rr
ip_vs_sh
ip_vs_wrr
nf_conntrack_ipv4
EOF

# Dependências
apt-get update -y
apt-get install -y curl ansible vim wget stress elinks git net-tools default-jre bash-completion python-ipaddress nfs-commo

# Docker and K8s
curl -fsSL https://get.docker.com | bash
apt-get update && apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list

apt-get update && apt-get install -y kubelet kubeadm kubectl

mkdir -p /etc/systemd/system/docker.service.d
cp /vagrant/files/daemon.json /etc/docker/daemon.json

systemctl daemon-reload
systemctl restart docker

kubeadm config images pull

# Kubernetes worker add adicionar
sudo /vagrant/files/token.sh
