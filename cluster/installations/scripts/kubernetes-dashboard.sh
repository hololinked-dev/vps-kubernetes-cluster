#!/bin/sh

# Run this instead of skaffold to install kubernetes-dashboard on the cluster whenever you need it.
# Add the Kubernetes Dashboard Helm repository
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update

# Install the Kubernetes Dashboard
helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
    --namespace kubernetes-dashboard \
    --create-namespace