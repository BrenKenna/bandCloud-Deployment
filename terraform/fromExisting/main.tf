# Spin up example instance from image
resource "aws_instance" "terraFormTesting" {

    ami = var.pubSub["ami"]
    instance_type = "t2.micro"
    subnet_id = var.publicSubnet_a["id"]
    key_name = var.bandCloudVPC["key"]
    security_groups = [ var.pubSub["sgID"] ]
    iam_instance_profile  = var.pubSub["iamRole"]


    tags = {
        Name = var.pubSub["instanceName"]
    }

    

    user_data = <<-EOF
                #!/bin/bash
                mkdir -p /workspace/bandCloud && cd /workspace/bandCloud
                sudo yum update -y
                aws s3 cp s3://__/__/___/___/bandCloud-App.tar.gz ./
                tar -xf bandCloud-App.tar.gz && cd hostedApp
                curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
                sudo yum install -y nodejs gcc-c++ make git
                sudo npm i aws-sdk express
                nohup sudo node app/dynamo/dynamo-server.js &>> /workspace/webApplog-2.txt &
                EOF
}
