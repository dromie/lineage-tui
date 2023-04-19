#!/bin/bash -x
NS=${NS:-lineage-$USER}
IMAGE=${IMAGE:-dromie/lineage-tui}
kubectl create ns $NS --dry-run=client -o yaml|kubectl apply -f -

kubectl -n $NS create sa lineage --dry-run=client -o yaml|kubectl apply -f -
kubectl create clusterrolebinding lineage-cluster-admin-$USER --clusterrole=cluster-admin --serviceaccount=$NS:lineage --dry-run=client -o yaml|kubectl apply -f -
kubectl -n $NS run -it lineage --image=$IMAGE --overrides='{ "spec": { "serviceAccount": "lineage" } }'
kubectl -n $NS delete pod lineage --force --grace-period=0
kubectl delete ns $NS --force --grace-period=0
