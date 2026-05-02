#!/bin/bash
set -euo pipefail

echo "Installing Gateway API"
kubectl apply -k gateway-api

echo "Installing Cilium"
cilium install --version 1.19.3 -f cilium/values.yaml --wait

echo "Installing ArgoCD"
kubectl apply -n argocd --server-side --force-conflicts -k argocd
