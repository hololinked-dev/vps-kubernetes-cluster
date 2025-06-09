#!/bin/sh

helm install ingress ../manifests/helm/ingress/. \
    --namespace simulators --create-namespace \
    --values ../manifests/helm/ingress-custom-routes/values-simulators.yaml \
    --set nameOverride=simulators-ingress \
    --dry-run --debug