#!/bin/bash
set -euo pipefail

echo "Installing Gateway API"
kubectl apply -k gateway-api

echo "Installing Cilium"
helm install cilium oci://quay.io/cilium/charts/cilium \
  --namespace kube-system \
  --values cilium/values.yaml \
  --wait=watcher

echo "Installing Flux"
helm install flux-operator oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator \
  --namespace flux-system \
  --create-namespace \
  --values flux/values.yaml \
  --wait=watcher

echo "Configuring Flux"
kubectl apply -f ../infrastrucutre/flux-operator/flux-instance.yaml
