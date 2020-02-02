#!/bin/bash

NAMESPACE=monitoring

kubectl -n $NAMESPACE delete cm graphite-config
kubectl -n $NAMESPACE delete -f ./
kubectl -n $NAMESPACE get pvc | grep "graphite-node-pv-graphite-node-" | awk {'print $1'} | xargs kubectl -n $NAMESPACE delete pvc