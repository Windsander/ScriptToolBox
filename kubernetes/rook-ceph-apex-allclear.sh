#!/bin/bash

#cd /etc/kubernetes/
#kubectl delete -f rook-ceph-prometheus.yaml

#cd rook/deploy/examples/monitoring
#kubectl delete -f rbac.yaml
#kubectl delete -f prometheus.yaml
#kubectl delete -f service-monitor.yaml
#kubectl delete -f prometheus-service.yaml

cd /etc/kubernetes/
kubectl delete -f rook-ceph-cluster.yaml
kubectl delete -f rook-ceph-operator.yaml
kubectl delete -f rook-ceph-common.yaml
kubectl delete -f rook-ceph-crds.yaml

kubectl get pods -n rook-ceph
