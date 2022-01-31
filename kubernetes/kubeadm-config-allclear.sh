#!/bin/bash

kubeadm reset -f

systemctl stop docker
systemctl stop kubelet
#systemctl status kubelet

rm -rf /var/lib/cni/
rm -rf /var/lib/Kubelet/*
rm -rf /etc/cni/
ifconfig cni0 down
ifconfig flannel.1 down
ifconfig Docker0 down
ip link delete cni0
ip link delete flannel.1

etcdctl del / --prefix
ipvsadm --clear
iptables -F

etcdctl get / --prefix --keys-only

systemctl start docker
systemctl start kubelet

ip addr flush dev kube-ipvs0
