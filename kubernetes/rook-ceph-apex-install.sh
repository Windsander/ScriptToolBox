#!/bin/bash

cd /etc/kubernetes/
kubectl create -f rook-ceph-crds.yaml
kubectl create -f rook-ceph-common.yaml
kubectl create -f rook-ceph-operator.yaml

#kubectl create -f rook-ceph-prometheus.yaml

#cd rook/deploy/examples/monitoring
#kubectl create -f rbac.yaml
#kubectl create -f prometheus.yaml
#kubectl create -f service-monitor.yaml
#kubectl create -f prometheus-service.yaml

cd /etc/kubernetes/
kubectl create -f rook-ceph-cluster.yaml

kubectl get pods -n rook-ceph
