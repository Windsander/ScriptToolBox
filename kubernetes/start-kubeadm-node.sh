#!/bin/bash
kubeadm join 192.168.122.254:6443 --token a2l8dl.ednopxlsd9gyvk53 \
	--discovery-token-ca-cert-hash sha256:085c54a878f082a38af7938d5cd9ab168514f0a0c34019bc42c7ad30114e1b36 
