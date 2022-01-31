#!/bin/bash
kubectl apply -f rook-ceph-rbd.yaml
kubectl apply -f rook-ceph-rbd-pvc.yaml

kubectl apply -f rook-ceph-cephfs.yaml
kubectl apply -f rook-ceph-cephfs-sc.yaml
kubectl apply -f rook-ceph-cephfs-pvc.yaml

kubectl patch storageclass k8s-default-cephfs-sc -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-defalut-class":"true"}}}'

