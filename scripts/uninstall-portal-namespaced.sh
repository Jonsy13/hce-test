#!/bin/bash

namespace=${PORTAL_NAMESPACE}

kubectl delete workflows --all -A
kubectl delete cronworkflows --all -A
kubectl delete chaosengines --all -A
kubectl delete chaosresult --all -A

# Shutting down the HCE-Onprem Setup
kubectl delete -f https://hce.chaosnative.com/manifests/ci/hce-crds.yaml
kubectl delete -f https://hce.chaosnative.com/manifests/ci/hce-namespace.yaml -n ${namespace}

