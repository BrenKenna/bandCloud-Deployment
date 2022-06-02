# Get aws linux & install common packages
FROM amazonlinux:latest AS osLayer
WORKDIR /workspace/

# Install updates & things around node
RUN yum update -y \
    && yum install -y amazon-linux-extras gcc-c++ make git aws-cli tar time hostname jq

# Install node
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash - \
    && yum install -y nodejs \
    && npm i -g aws-sdk express

# Install app
RUN aws s3 cp s3://bandcloud/app/bandCloud-Docker.tar.gz ./ \
    && tar -xf bandCloud-Docker.tar.gz

# Run app
WORKDIR /workspace/bandCloud-App
#RUN node app/dynamo-server.js
#EXPOSE 8080 CMD ["node", "app/dynamo-server.js", "8080"]
#EXPOSE 8080 CMD ["node", "8080", "app/dynamo-server.js"]