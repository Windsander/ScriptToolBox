#!/bin/bash
kubectl delete -f rook-ceph-rbd.yaml
kubectl delete -f rook-ceph-rbd-pvc.yaml

kubectl delete -f rook-ceph-cephfs.yaml
kubectl delete -f rook-ceph-cephfs-sc.yaml
kubectl delete -f rook-ceph-cephfs-pvc.yaml

#kubectl patch storageclass k8s-default-cephfs-sc -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-defalut-class":"true"}}}'

