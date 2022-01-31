#!/bin/bash

K8S_NAMESPACE=kube-jupyterhub
HELM_RELEASE_NAME=kube-jupyterhub
HELM_CHART_NAME=jupyterhub
#HELM_VERSION=1.2.0

helm upgrade --cleanup-on-fail \
 --install $HELM_RELEASE_NAME jupyterhub/$HELM_CHART_NAME \
 --namespace $K8S_NAMESPACE --create-namespace \
 --values jupyterhub-config.yaml | tee jupyterhub-init.log

kubectl get pods -n $K8S_NAMESPACE
