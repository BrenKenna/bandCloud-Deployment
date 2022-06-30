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
ELB_DNS=$(aws elbv2 describe-load-balancers --names "be-app-elb" --region ${REGION} | jq .LoadBalancers[0].DNSName | sed 's/"//g')
if [ -z ${ELB_DNS} ]
then
    echo -e "\nError, unable to find BE-DNS running as is for debugging"
else
    sed "s/TEMPLATE_ELB_DNS/${ELB_DNS}/g" file-explorer/dist-server.js > file-explorer/dist-server.js.out
    mv file-explorer/dist-server.js.out file-explorer/dist-server.js
fi


# Run server
cd file-explorer
node dist-server.js