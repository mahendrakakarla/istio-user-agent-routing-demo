#!/usr/bin/env bash
kubectl -n istio-system port-forward svc/istio-ingressgateway 8080:80
