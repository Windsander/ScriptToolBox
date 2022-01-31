#!/bin/bash

kubectl apply -f ingress-nginx-deploy.yaml
kubectl apply -f ingress-establish.yaml
kubectl apply -f ingress-cert-manager.yaml
kubectl apply -f ingress-cert-manager-selfsigned.yaml

kubectl apply -f ingress-rook-ceph.yaml
kubectl apply -f ingress-monitoring.yaml

kubectl get ingress --all-namespaces
