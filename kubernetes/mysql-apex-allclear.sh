# deploy master-slave cluster

kubectl label nodes master1 master2 master3 "mysql=master"-
kubectl label nodes node1 node2 node3 node4 "mysql=slave"-

kubectl delete -f mysql-innodb-node.yaml
kubectl delete -f mysql-innodb-master.yaml
kubectl delete -f mysql-innodb-service.yaml
kubectl delete -f mysql-storage-pvc.yaml
kubectl delete -f mysql-secret.yaml

#!/bin/bash

kubectl get statefulset -n rook-mysql | awk '{print $1}' | xargs kubectl delete statefulset -n rook-mysql
kubectl get replicaset -n rook-mysql | awk '{print $1}' | xargs kubectl delete replicaset -n rook-mysql
kubectl get daemonset -n rook-mysql | awk '{print $1}' | xargs kubectl delete daemonset -n rook-mysql
kubectl get deployment -n rook-mysql | awk '{print $1}' | xargs kubectl delete deployment -n rook-mysql
kubectl get svc -n rook-mysql | awk '{print $1}' | xargs kubectl delete svc -n rook-mysql
kubectl get pods -n rook-mysql | awk '{print $1}' | xargs kubectl delete pods -n rook-mysql
kubectl get secret -n rook-mysql | awk '{print $1}' | xargs kubectl delete secret -n rook-mysql

kubectl get all -n rook-mysql
kubectl delete ns rook-mysql

kubectl get ns
