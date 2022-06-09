#!/bin/bash

#######################################
#######################################
#
# Notes on how to do background things
# 
# Next main steps:
#   a). Load balancing domain (enable registration)
#   b). Registration in an ECR repo
#        => Fix for undefined
#
#   c). Start consolidating into the app
#
########################################
########################################

################
# 
# Basics
# 
################

# Install express and https
npm i express https

# Git ignore for the certs etc
echo -e "
    certs/*
" > .gitignore

# Generate self-signed cert
openssl genrsa -out key.pem
openssl req -new -key key.pem -out csr.pem
openssl x509 -req -days 30 -in csr.pem -signkey key.pem -out cert.pem


# Certificate conversion
openssl pkcs12 -export -in certificatename.cer -inkey privateKey.key -out certificatename.pfx -certfile  cacert.cer
openssl pkcs12 -export -out cert.p12 -in cert.pem -inkey key.pem

openssl pkcs12 -export -out aws.p12 -in certificate.pem -inkey private-key.pem


# Start node server
node index.js

"
Server listening on port = 8000, address = 127.0.0.1

"


##############################################
##############################################
# 
# AWS:
#   - Enabled DNS hostname resolution in VPC
# 
##############################################
##############################################

# Copy files
ssh -i bandCloud.pem ec2-user@ec2-54-194-66-202.eu-west-1.compute.amazonaws.com  "mkdir -p ~/hostedApp/app"
scp -i bandCloud.pem -r app/* ec2-user@ec2-54-155-250-180.eu-west-1.compute.amazonaws.com:~/hostedApp/app/

# Login
ssh -i bandCloud.pem ec2-user@ec2-54-155-250-180.eu-west-1.compute.amazonaws.com


# Basic updates etc
sudo yum update -y


# UFW-Messes with Security Group
'''
    sudo amazon-linux-extras install epel # yum install -y epel-release
    sudo yum install -y ufw # Allow traffic through port 8080: stop application running as root
    sudo ufw enable -y
    sudo ufw allow 8080/tcp
'''

# Add nodejs repo: Upgraded to the recommended 14 version
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo yum install -y nodejs git gcc-c++ make


###################
# 
# Client based
# 
###################

# Install node-sdk after init
npm i aws-sdk express axios


# Configure client: eu-west-1
aws configure


# Create a private s3 bucket
aws s3 mb s3://bandcloud --region eu-west-1
aws s3api put-public-access-block --bucket bandcloud
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"


# Archive app to S3
cd ~/
tar -czf bandCloud-App.tar.gz hostedApp
aws s3 cp bandCloud-App.tar.gz s3://bandcloud/app/

aws s3 cp s3://bandcloud/app/bandCloud-App.tar.gz ./
tar -xvf bandCloud-App.tar.gz


# Copy archive from instance
scp -i bandCloud.pem -r ec2-user@ec2-54-155-250-180.eu-west-1.compute.amazonaws.com:~/bandCloud-App.tar.gz ./


# Copy cert & key
scp -i bandCloud.pem certs/* ec2-user@ec2-54-74-102-170.eu-west-1.compute.amazonaws.com:"/home/ec2-user/hostedApp/certs/"



###############
#
# User Data
#
###############

# Sanity check
ssh -i bandCloud.pem ec2-user@ec2-34-244-43-187.eu-west-1.compute.amazonaws.com 

# Get app
mkdir -p /workspace/bandCloud
cd /workspace/bandCloud
sudo yum update -y
aws s3 cp s3://bandcloud/app/bandCloud-App.tar.gz ./
tar -xf bandCloud-App.tar.gz
cd hostedApp


# Install sotware
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo yum install -y nodejs gcc-c++ make git
npm i aws-sdk express


# Start app
node app/index.js


###############
# 
# Other
# 
###############


# Issue pre-signed URL: Does not work for directory
aws s3 presign s3://bandcloud/test/test.txt --expires-in 120



##############################
##############################
#
# cURL Req
# 
##############################
##############################

# For packnet sniffing
for i in $(seq 100); do curl -k -X POST http://localhost:8080/login -H "Content-Type: application/json" -d '{"username": 123456, "password": 100}'; sleep 1s; done



# Check response from posting a login
curl -k -X POST https://localhost:8080/login -H "Content-Type: application/json" -d '{"username": 123456, "password": 100}'

"""
Postman recieves response but a

"""

# Post to web app
curl -k -X POST http://3.249.240.203:8080/reg -H "Content-Type: application/json" -d '{"username": "tom", "password": apples, "email": "hello@yolo.com"}'


###################################
# 
# Terraform
# 
###################################


# centos/amz linux: swap AmazonLinux for REHL
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform


export AWS_ACCESS_KEY=$(grep "id" ~/.aws/credentials | cut -d \= -f 2 | sed 's/ \+//g')
export AWS_SECRET_ACCESS_KEY=$(grep "secret" ~/.aws/credentials | cut -d \= -f 2 | sed 's/ \+//g')


# Initalize and inspect
terraform init
teraform plan # Output here quite useful to check TF related vars etc

# Create/update infrastructure
terraform apply

# Destroy infrastructure
terraform destory

# List resource in state
teraform state list



##################################
# 
# ECR
# 
##################################


# Update node-server
cd ~
rm -f bandCloud-Docker.tar.gz
tar -czf bandCloud-Docker.tar.gz bandCloud-App/
aws s3 cp bandCloud-Docker.tar.gz s3://bandcloud/app/


# Install & login
rm -f ~/.docker/config.json
sudo yum install -y amazon-linux-extras docker
sudo service docker start
sudo usermod -a -G docker ec2-user
aws ecr get-login-password | docker login --username AWS --password-stdin 017511708259.dkr.ecr.eu-west-1.amazonaws.com/bandcloud


# Build & push
cd ~/bandCloud-App
docker build --no-cache -t bandcloud .
docker tag bandcloud:latest 017511708259.dkr.ecr.eu-west-1.amazonaws.com/bandcloud:latest
docker push 017511708259.dkr.ecr.eu-west-1.amazonaws.com/bandcloud:latest


docker image rm bandcloud


# List local images
docker images

# Test run in background & check-in
docker run -d -p 8080:8080 bandcloud node app/dynamo-server.js
docker ps
docker stats


# Run interactively
docker run -it -p 8080:8080 017511708259.dkr.ecr.eu-west-1.amazonaws.com/bandcloud
bash app/launchServer.sh eu-west-1


# Maintenance: Disk usage, clearable containers, remove them
docker system df
docker ps --filter status=exited --filter status=dead -q
docker rm $(docker ps --filter=status=exited --filter=status=dead -q)
docker container prune -f


# Prune images
docker image prune -f



###################################
#
# Webserver Launch Script
#
###################################

# Login
ssh -i bandCloud.pem ec2-user@ec2-34-247-12-14.eu-west-1.compute.amazonaws.com


# ELB
ELB_DNS=$(aws elbv2 describe-load-balancers --names "tf-app-elb" | jq .LoadBalancers[0].DNSName | sed 's/"//g')
cd app
for toEdit in $(find . -name "index.html" | cut -d \/ -f 2-)
    do
    sed "s/TEMPLATE_ELB_DNS/${ELB_DNS}/g" ${toEdit} > ${toEdit}.out
    mv ${toEdit}.out ${toEdit} 
done


# Run server
node app/dynamo-server.js



#################################
# 
# S3 Stuff:
#   a). Presigned URL
#   b). Tagging
# 
#################################


# Generate pre-signed URL for an S3 object that expires in 60s
aws s3 presign s3://bandcloud/test/test.txt --expires 60


# Tag an s3 file
aws s3api put-object-tagging --bucket bandcloud --key test/test.txt --tagging '{"TagSet": [{ "Key": "Creator", "Value": "Me" }]}'


# Drop tag on s3 file
aws s3api delete-object-tagging --bucket bandcloud --key test/test.txt


# Get an S3 tag
aws s3api get-object-tagging --bucket bandcloud --key test/test.txt | jq .TagSet[0].Value | sed 's/"//g'




################################
#
# Install java-16 :(
#
#   - Fix Eclipse IDE later for 18
# 
################################


# Install coretto-aws ?
sudo rpm --import https://yum.corretto.aws/corretto.key 
sudo curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
sudo yum install -y java-16-amazon-corretto-devel
sudo yum update -y 


# Check version
java -version

'
Works fine whatever Corretto is

openjdk version "16.0.2" 2021-07-20
OpenJDK Runtime Environment Corretto-16.0.2.7.1 (build 16.0.2+7)
OpenJDK 64-Bit Server VM Corretto-16.0.2.7.1 (build 16.0.2+7, mixed mode, sharing)
'


# Run server
java -jar build/libs



# Check endpoints
curl -k -X GET http://34.247.12.14:8080/ec2

'
{
    "imageId":"ami-0c1bc246476a5572b","instanceId":"i-0a9eff28b795805ad","instanceName":"tfBastion",
    "instanceType":"t2.micro","availZone":"eu-west-1a","state":"running",
    "hypervisor":"xen","creationDate":"2022-05-31T13:48:28.000+00:00"
}


'


################################
#
# Package into container
#
################################

# Setup folder
mkdir ~/spring-backend
unzip app.zip
mv build ~/spring-backend

# Archive to S3
tar -czf ~/REST_API.tar.gz build/
aws s3 cp ~/REST_API.tar.gz s3://bandcloud/app/


# Install & login
rm -f ~/.docker/config.json
sudo yum install -y amazon-linux-extras docker
sudo service docker start
sudo usermod -a -G docker ec2-user
aws ecr get-login-password | docker login --username AWS --password-stdin 017511708259.dkr.ecr.eu-west-1.amazonaws.com/bandcloud-backend


# Clear space
docker container prune -f && docker image prune -f

# Build & push
docker build --no-cache -t bandcloud-backend .
docker tag bandcloud-backend:latest 017511708259.dkr.ecr.eu-west-1.amazonaws.com/bandcloud-backend:latest
docker push 017511708259.dkr.ecr.eu-west-1.amazonaws.com/bandcloud-backend:latest


# Sanity check
docker run -it -p 8080:8080 017511708259.dkr.ecr.eu-west-1.amazonaws.com/bandcloud-backend