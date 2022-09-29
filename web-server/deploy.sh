#!/bin/bash -ex
service=web-server
k8s_host=kind

usage() {
  echo '$ ./deploy <development|production> <tag>'
}
if [  $# -ne 1 -a $# -ne 2]; then usage; exit 1; fi
if [ "$1" != "development" -a "$1" != "production" ]; then usage; exit 1; fi
env=$1
tag=$2
cluster_name=${k8s_host}-${env}

kubectl config use-context $cluster_name
helm template --set-string "image.name=${service},image.tag=${tag},env=${env}" ./ > ${service}.yaml
kubectl apply --prune -l app=${service} --record=true -f ${service}.yaml
rm ${service}.yaml
