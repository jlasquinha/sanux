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
apt-get install -y ansible curl default-jre vim wget stress elinks git net-tools bash-completion python-ipaddress nfs-kernel-server
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

# Kubernetes master config

echo "KUBELET_EXTRA_ARGS='--node-ip=172.27.11.110'" > /etc/default/kubelet
kubeadm config images pull

cd ~
kubeadm init --apiserver-advertise-address 172.27.11.110 --pod-network-cidr 172.27.11.0/24 > /tmp/token2.sh


echo "#!/bin/bash" > /tmp/token.sh
tail -2 /tmp/token2.sh  >> /tmp/token.sh
cp /tmp/token.sh /vagrant/files/token.sh

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

#App
mkdir /root/exemplos

cp /vagrant/files/exemplos/configmap-metallb.yaml  /root/exemplos/configmap-metallb.yaml          
cp /vagrant/files/exemplos/primeiro_deployment.yaml /root/exemplos/primeiro_deployment.yaml         
cp /vagrant/files/exemplos/primeiro_namespace.yaml /root/exemplos/primeiro_namespace.yam
cp /vagrant/files/exemplos/primeiro_pod.yaml /root/exemplos/primeiro_pod.yaml                 
cp /vagrant/files/exemplos/primeiro_servico.yaml /root/exemplos/primeiro_servico.yaml             
cp /vagrant/files/exemplos/primeiro_servico_LoadBalancer.yaml /root/exemplos/primeiro_servico_LoadBalancer.yaml
cp /vagrant/files/exemplos/primeiro_servico_NodePort.yaml /root/exemplos/primeiro_servico_NodePort.yaml


# Ansible Config
cp /vagrant/files/hosts /etc/ansible/hosts
cp /vagrant/files/ansible.cfg /etc/ansible/ansible.cfg
cp /vagrant/files/key /root/.ssh/id_rsa; chmod 400 /root/.ssh/id_rsa 
cp /vagrant/files/key.pub /root/.ssh/id_rsa.pub
sed -i -e "s/#host_key_checking/host_key_checking/" /etc/ansible/ansible.cfg
sed -i -e "s@#private_key_file = /path/to/file@private_key_file = /root/.ssh/id_rsa@" /etc/ansible/ansible.cfg











