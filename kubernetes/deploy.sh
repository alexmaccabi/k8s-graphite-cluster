#!/bin/bash

NAMESPACE=monitoring

./01-configmap.sh $NAMESPACE
kubectl -n $NAMESPACE apply -f ./