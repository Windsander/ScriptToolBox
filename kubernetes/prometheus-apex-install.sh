#!/bin/bash

cd /etc/kubernetes/prometheus/

#install setup
kubectl apply --server-side -f manifests/setup/
kubectl apply -f manifests/

#install operator
#kubectl apply -f prometheusOperator-clusterRole.yaml
#kubectl apply -f prometheusOperator-clusterRoleBinding.yaml
#kubectl apply -f prometheusOperator-deployment.yaml
#kubectl apply -f prometheusOperator-prometheusRule.yaml
#kubectl apply -f prometheusOperator-service.yaml
#kubectl apply -f prometheusOperator-serviceAccount.yaml
#kubectl apply -f prometheusOperator-serviceMonitor.yaml

#install adapter
#kubectl apply -f prometheusAdapter-apiService.yaml
#kubectl apply -f prometheusAdapter-clusterRole.yaml
#kubectl apply -f prometheusAdapter-clusterRoleAggregatedMetricsReader.yaml
#kubectl apply -f prometheusAdapter-clusterRoleBinding.yaml
#kubectl apply -f prometheusAdapter-clusterRoleBindingDelegator.yaml
#kubectl apply -f prometheusAdapter-configMap.yaml
#kubectl apply -f prometheusAdapter-deployment.yaml
#kubectl apply -f prometheusAdapter-podDisruptionBudget.yaml
#kubectl apply -f prometheusAdapter-roleBindingAuthReader.yaml
#kubectl apply -f prometheusAdapter-service.yaml
#kubectl apply -f prometheusAdapter-serviceAccount.yaml
#kubectl apply -f prometheusAdapter-serviceMonitor.yaml

#install alertmanager
#kubectl apply -f alertmanager-alertmanager.yaml
#kubectl apply -f alertmanager-podDisruptionBudget.yaml
#kubectl apply -f alertmanager-prometheusRule.yaml
#kubectl apply -f alertmanager-secret.yaml
#kubectl apply -f alertmanager-service.yaml
#kubectl apply -f alertmanager-serviceAccount.yaml
#kubectl apply -f alertmanager-serviceMonitor.yaml

#install exporter
#kubectl apply -f blackboxExporter-clusterRole.yaml
#kubectl apply -f blackboxExporter-clusterRoleBinding.yaml
#kubectl apply -f blackboxExporter-configuration.yaml
#kubectl apply -f blackboxExporter-deployment.yaml
#kubectl apply -f blackboxExporter-service.yaml
#kubectl apply -f blackboxExporter-serviceAccount.yaml
#kubectl apply -f blackboxExporter-serviceMonitor.yaml

#install metrics
#kubectl apply -f kubePrometheus-prometheusRule.yaml
#kubectl apply -f kubeStateMetrics-clusterRole.yaml
#kubectl apply -f kubeStateMetrics-clusterRoleBinding.yaml
#kubectl apply -f kubeStateMetrics-deployment.yaml
#kubectl apply -f kubeStateMetrics-prometheusRule.yaml
#kubectl apply -f kubeStateMetrics-service.yaml
#kubectl apply -f kubeStateMetrics-serviceAccount.yaml
#kubectl apply -f kubeStateMetrics-serviceMonitor.yaml

#install Prometheus
#kubectl apply -f prometheus-clusterRole.yaml
#kubectl apply -f prometheus-clusterRoleBinding.yaml
#kubectl apply -f prometheus-podDisruptionBudget.yaml
#kubectl apply -f prometheus-prometheus.yaml
#kubectl apply -f prometheus-prometheusRule.yaml
#kubectl apply -f prometheus-roleBindingConfig.yaml
#kubectl apply -f prometheus-roleBindingSpecificNamespaces.yaml
#kubectl apply -f prometheus-roleConfig.yaml
#kubectl apply -f prometheus-roleSpecificNamespaces.yaml
#kubectl apply -f prometheus-service.yaml
#kubectl apply -f prometheus-serviceAccount.yaml
#kubectl apply -f prometheus-serviceMonitor.yaml

#install grafana
#kubectl apply -f grafana-config.yaml
#kubectl apply -f grafana-dashboardDatasources.yaml
#kubectl apply -f grafana-dashboardDefinitions.yaml
#kubectl apply -f grafana-dashboardSources.yaml
#kubectl apply -f grafana-deployment.yaml
#kubectl apply -f grafana-prometheusRule.yaml
#kubectl apply -f grafana-service.yaml
#kubectl apply -f grafana-serviceAccount.yaml
#kubectl apply -f grafana-serviceMonitor.yaml

#install k8s-control-plane-monitor
#kubectl apply -f kubernetesControlPlane-prometheusRule.yaml
#kubectl apply -f kubernetesControlPlane-serviceMonitorApiserver.yaml
#kubectl apply -f kubernetesControlPlane-serviceMonitorCoreDns.yaml
#kubectl apply -f kubernetesControlPlane-serviceMonitorKubeControllerManager.yaml
#kubectl apply -f kubernetesControlPlane-serviceMonitorkubeScheduler.yaml
#kubectl apply -f kubernetesControlPlane-serviceMonitorKubelet.yaml

cd /etc/kubernetes/

kubectl get pods -n monitoring
