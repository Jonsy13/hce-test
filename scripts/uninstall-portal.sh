#!/bin/bash

kubectl delete workflows --all -A
kubectl delete cronworkflows --all -A
kubectl delete chaosengines --all -A
kubectl delete chaosresult --all -A

kubectl delete -f https://hce.chaosnative.com/manifests/ci/hce-cluster-scope.yaml
