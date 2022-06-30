####################################
# 
# Launch Configuration & ASG
# 
####################################

# Launch config
resource "aws_launch_configuration" "terraformLC-1a" {
    name = "tf-app-1a"
    # image_id = aws_ami.terraform-example-1a.id
    image_id = var.ec2_vars["ami_1a"]
    instance_type = var.ec2_vars["instanceType"]
    key_name = var.ec2_vars["key"]
    security_groups = [ aws_security_group.sg22.id, aws_security_group.httpAnywhere.id ]
    iam_instance_profile  = var.ec2_vars["iamRole"]
    associate_public_ip_address = true
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


###########################
# 
# Second subnet
# 
###########################

resource "aws_launch_configuration" "terraformLC-1b" {
    name = "tf-app-1b"
    # image_id = aws_ami.terraform-example-1b.id
    image_id = var.ec2_vars["ami_1b"]
    instance_type = var.ec2_vars["instanceType"]
    key_name = var.ec2_vars["key"]
    security_groups = [ aws_security_group.sg22.id, aws_security_group.httpAnywhere.id ]
    iam_instance_profile  = var.ec2_vars["iamRole"]
    associate_public_ip_address = true
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