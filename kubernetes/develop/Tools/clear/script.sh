#!/bin/bash
for pods in $(kubectl get pod -A | grep -e NodeAffinity -e Shutdown -e Error -e Terminated -e Terminating| sed 's/   */:/g')
do
  ns=$(echo $pods | cut -d : -f 1)
  pod=$(echo $pods | cut -d : -f 2)
  kubectl delete pod --grace-period=0 --force -n $ns $pod
  echo "Ok"
done
