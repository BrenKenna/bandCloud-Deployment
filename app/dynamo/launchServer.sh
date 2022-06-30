#!/bin/bash

######################################################################
######################################################################
# 
# Script to update html pages for ELB DNS and run server
# 
######################################################################
######################################################################


# Check input
REGION=$1
if [ -z ${REGION} ]
then
    echo -e "\nError, exiting no region provided"
fi

# Fetch ELB DNS and update relevant pages
ELB_DNS=$(aws elbv2 describe-load-balancers --names "tf-app-elb" --region ${REGION} | jq .LoadBalancers[0].DNSName | sed 's/"//g')
for toEdit in $(find app/ -name "index.html")
    do
    sed "s/TEMPLATE_ELB_DNS/${ELB_DNS}:8080/g" ${toEdit} > ${toEdit}.out
    mv ${toEdit}.out ${toEdit} 
done


# Run server
node app/dynamo-server.js