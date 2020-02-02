#!/bin/bash

NAMESPACE=$1

kubectl create configmap graphite-config --from-file=graphite-config --namespace $NAMESPACE