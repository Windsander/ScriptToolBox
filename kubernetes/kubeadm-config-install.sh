#!/bin/bash
kubeadm init --config=kubeadm-config-master.yaml | tee kubeadm-init.log

cp -f kubeadm-init.log start-kubeadm-join.sh
cp -f kubeadm-init.log start-kubeadm-node.sh
