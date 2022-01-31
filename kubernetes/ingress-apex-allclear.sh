#!/bin/bash

kubectl delete -f ingress-monitoring.yaml
kubectl delete -f ingress-rook-ceph.yaml

kubectl delete -f ingress-cert-manager-selfsigned.yaml
kubectl delete -f ingress-cert-manager.yaml
kubectl delete -f ingress-establish.yaml
kubectl delete -f ingress-nginx-deploy.yaml

kubectl get ingress --all-namespaces
