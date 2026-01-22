#!/usr/bin/env bash
set -e

istioctl install --set profile=demo -y
kubectl create namespace app-dev || true
kubectl label namespace app-dev istio-injection=enabled --overwrite
