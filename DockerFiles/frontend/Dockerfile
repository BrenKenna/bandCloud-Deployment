# Get aws linux & install common packages
FROM amazonlinux:latest AS osLayer
WORKDIR /workspace/

# Install updates & things around node
RUN yum update -y \
    && yum install -y amazon-linux-extras gcc-c++ make git aws-cli ls tar time hostname jq

# Install node
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash - \
    && yum install -y nodejs \
    && npm i -g express axios

# Install app
RUN aws s3 cp s3://bandcloud/app/bandCloud-Angular.tar.gz ./ \
    && tar -xf bandCloud-Angular.tar.gz

# Update start-up working directory
WORKDIR /workspace/ionic-file-explorer
# RUN ls