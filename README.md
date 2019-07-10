# k8s-graphite-cluster

A deployment-ready graphite cluster on top of Kubernetes.

## Contents:
1. **Carbon relay** deployment and service to spread metrics across several Graphite data nodes
2. **Graphite data nodes** as a stateful set with persistent volumes
3. **Graphite query node** to be used as a query gateway to the data nodes
5. **Config Map** used for storage schema 
4. **Graphite Version 1.1.5** I used the latests release

## Requirements:
1. Kubernetes version v1.11.x
2. kubectl configured to work with your Kubernetes API

## Deployment:
1. Clone this repository
2. Create Config Maps: kubectl create configmap graphite-config --from-file=graphite-config
3. Run: kubctl create for every compontent and service

## Usage:

1. **carbon-relay:2004** is the service pod for sending metrics with pickle protocol
2. **graphite:80** is the host for you metrics queries. It points to the graphite query node which queries all data nodes in the cluster.


## Verifying The Deployment:

kubectl port-forward svc/graphite 8080:80

//TODO

## Building your own images
If you need to change and edit docker images //TODO

## Changing an active cluster configuration

Graphite data nodes are deployed as StatefulSets.
Both Graphite master and carbon relays continuously watch the Kubernetes API for Graphite nodes endpoints and update the configuration.
You can scale deployments and statfull state accordingly to your own need.

## Example:

I had to keep 3 year of data, the data files were of diffrent sizes ranging between kilobytes to 128mb.
My config was: 

Carbon-relay: 6 nodes they used about 100 =~ 200 mb of memory 
Graphite-Data-Node: 4 with 2TB storage, standarad storage, I also utilized Redis for TagDB and memcached
This one is more resource intensive and scaled past 16g memory //TODO 
Graphite-Query-Node: 3 Nodes memory usage is about 200mb

I've been able to send between 250k to 1mil of messages, with no real issue. 
I used Grafana to connect to the Graphite-Query-Node, and been able to get data past 2 year with no real performance issue.

## Acknowledgement

I've learned and used some of the elements from this articale thanks to Nanit and Erez Rabih [This article](https://engineering.nanit.com/creating-a-graphite-cluster-on-kubernetes-6b402a8a7438)