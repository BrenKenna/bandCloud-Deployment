##################################
# 
# Spinup Instance in new VPC
# 
##################################

# Spin up example instance from image
resource "aws_instance" "terraFormTesting-a" {
    # ami = aws_ami.terraform-example-1a.id
    ami = var.ec2_vars["ami_1a"]
    instance_type = var.ec2_vars["instanceType"]
    subnet_id = aws_subnet.pubSub_A.id
    key_name = var.ec2_vars["key"]
    security_groups = [ aws_security_group.sg22.id, aws_security_group.httpAnywhere.id ]
    iam_instance_profile  = var.ec2_vars["iamRole"]
    associate_public_ip_address = true
    tags = {
        Name = "terraformApp-PubSub-A"
    }

    user_data = <<-EOF
                #!/bin/bash
                mkdir -p /workspace/bandCloud && cd /workspace/bandCloud
                sudo yum update -y
                aws s3 cp s3://bandcloud/app/bandCloud-App.tar.gz ./
                tar -xf bandCloud-App.tar.gz && cd hostedApp
                curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
                sudo yum install -y nodejs gcc-c++ make git
                sudo npm i aws-sdk express cookie-parser
                nohup sudo node app/dynamo/dynamo-server.js &>> /workspace/webApplog-2.txt &
                EOF
}


# Zone 2
resource "aws_instance" "terraFormTesting-b" {
    # ami = aws_ami.terraform-example-1b.id
    ami = var.ec2_vars["ami_1b"]
    instance_type = var.ec2_vars["instanceType"]
    subnet_id = aws_subnet.pubSub_B.id
    key_name = var.ec2_vars["key"]
    security_groups = [ aws_security_group.sg22.id, aws_security_group.httpAnywhere.id ]
    iam_instance_profile  = var.ec2_vars["iamRole"]
    associate_public_ip_address = true
    tags = {
        Name = "terraformApp-PubSub-B"
    }

    user_data = <<-EOF
                #!/bin/bash
                mkdir -p /workspace/bandCloud && cd /workspace/bandCloud
                sudo yum update -y
                aws s3 cp s3://bandcloud/app/bandCloud-App.tar.gz ./
                tar -xf bandCloud-App.tar.gz && cd hostedApp
                curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
                sudo yum install -y nodejs gcc-c++ make git
                sudo npm i aws-sdk express
                nohup sudo node app/dynamo/dynamo-server.js &>> /workspace/webApplog-2.txt &
                EOF
}