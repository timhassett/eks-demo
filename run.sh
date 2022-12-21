#!/bin/bash

terraform init
terraform apply --auto-approve

HOSTNAME=`kubectl get svc ingress-nginx-controller -n ingress-nginx --output jsonpath='{.status.loadBalancer.ingress[0].hostname}'`

if [ $? -eq 0 ]; then
    echo "LB DNS name:  $HOSTNAME"
fi

