#!/usr/bin/env bash
NS=${NS:-lineage-$USER}
IMAGE=${IMAGE:-dromie/lineage-tui}
if [ $# -lt 1 ];then
  if kubectl get pod -n $NS lineage;then
    kubectl -n $NS exec -it lineage -- screen -RRD
  else
    $0 create
  fi
elif [ "$1" == "create" ];then
  kubectl create ns $NS --dry-run=client -o yaml|kubectl apply -f -
  kubectl -n $NS create sa lineage --dry-run=client -o yaml|kubectl apply -f -
  kubectl create clusterrolebinding lineage-cluster-admin-$USER --clusterrole=cluster-admin --serviceaccount=$NS:lineage --dry-run=client -o yaml|kubectl apply -f -
  kubectl -n $NS run lineage --image=$IMAGE --overrides='{ "spec": { "serviceAccount": "lineage" } }' -- sleep infinity
  kubectl -n $NS wait pod --for=condition=Ready lineage
  kubectl -n $NS exec -it lineage -- screen
elif [ "$1" == "delete" ];then
  kubectl -n $NS delete pod lineage --force --grace-period=0
  kubectl delete ns $NS --force --grace-period=0
fi
