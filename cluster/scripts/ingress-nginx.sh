#!/bin/sh

# Run this instead of skaffold to install ingress-nginx on the cluster whenever you need it.
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm --kube-context kubernetes-admin@kubernetes \
  install ingress-nginx ingress-nginx/ingress-nginx \
  --version 4.11.2 \
  --namespace default \
  --set controller.service.externalTrafficPolicy=Local \
  --set controller.service.type=NodePort \
  --set controller.ingressClassResource.name=nginx \
  --set controller.ingressClassResource.controllerValue=${TOP_LEVEL_DOMAIN}/ingress-nginx