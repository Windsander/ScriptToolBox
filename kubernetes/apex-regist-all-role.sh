#!/bin/bash
kubectl label nodes master1 master2 master3 node1 node2 role=storage-node

kubectl taint nodes master1 master2 master3 node1 node2 storage-node:NoSchedule-
kubectl taint nodes master1 master2 master3 node-role.kubernetes.io/master:NoSchedule-

kubectl label nodes master1 master2 master3 role/ingress=ingress-entry
kubectl label nodes master1 master2 master3 role/cephfs=mds-node
