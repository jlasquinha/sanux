#!/bin/bash
kubeadm join 172.27.11.110:6443 --token jye11o.qabxcyk5o12uee70 \
	--discovery-token-ca-cert-hash sha256:39e05d8650354667afb1d1451985b75075849d89ab032a4ddebb93466205b72b 
