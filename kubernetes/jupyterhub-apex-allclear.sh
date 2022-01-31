#!/bin/bash

kubectl get statefulset -n kube-jupyterhub | awk '{print $1}' | xargs kubectl delete statefulset -n kube-jupyterhub
kubectl get replicaset -n kube-jupyterhub | awk '{print $1}' | xargs kubectl delete replicaset -n kube-jupyterhub
kubectl get daemonset -n kube-jupyterhub | awk '{print $1}' | xargs kubectl delete daemonset -n kube-jupyterhub
kubectl get deployment -n kube-jupyterhub | awk '{print $1}' | xargs kubectl delete deployment -n kube-jupyterhub
kubectl get svc -n kube-jupyterhub | awk '{print $1}' | xargs kubectl delete svc -n kube-jupyterhub
kubectl get pods -n kube-jupyterhub | awk '{print $1}' | xargs kubectl delete pods -n kube-jupyterhub

kubectl delete -f ingress-jupyterhub.yaml
kubectl delete ns kube-jupyterhub

kubectl get ns
