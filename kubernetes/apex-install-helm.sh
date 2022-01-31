#!/bin/bash

#curl https://raw.githubusercontent.com/helm/helm/HEAD/scripts/get-helm-3 | bash
helm version

helm repo add stable https://charts.helm.sh/stable
helm repo add incubator https://charts.helm.sh/incubator
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add aliyuncs https://apphub.aliyuncs.com
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo add jumpserver https://jumpserver.github.io/helm-charts
helm repo update

helm repo list
