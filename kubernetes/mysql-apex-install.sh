# deploy master-slave cluster

kubectl label nodes master1 master2 master3 mysql=master
kubectl label nodes node1 node2 node3 node4 mysql=slave

kubectl create ns rook-mysql

# store account in secret
kubectl apply -f mysql-secret.yaml

#deploy storage
kubectl apply -f mysql-storage-pvc.yaml

# deploy basic service
kubectl apply -f mysql-innodb-service.yaml

# deploy primary nodes
kubectl apply -f mysql-innodb-master.yaml

# deploy secondary nodes
kubectl apply -f mysql-innodb-node.yaml

kubectl get all -n rook-mysql
