#!/bin/bash

K8S_NAMESPACE=kube-jumpserver
HELM_RELEASE_NAME=kube-jumpserver
HELM_CHART_NAME=jumpserver
#HELM_VERSION=v2.18.1

helm install $HELM_RELEASE_NAME jumpserver/$HELM_CHART_NAME \
 --namespace $K8S_NAMESPACE \
 --values jumpserver-config.yaml

kubectl get pods -n $K8S_NAMESPACE
