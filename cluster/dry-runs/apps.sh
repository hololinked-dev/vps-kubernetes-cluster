#!/bin/sh

helm install apps manifests/helm/apps/. \
    --namespace apps \
    --create-namespace \
    --set nameOverride=oscilloscope-simulator \
    --set image.repository=ghcr.io/vigneshvsv/oscilloscope-simulator \
    --set image.pullPolicy=Always \
    --set image.tag=main \
    --set image.ports.containerPort=5000 \
    --dry-run --debug