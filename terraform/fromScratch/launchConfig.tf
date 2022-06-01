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

                # Setup and install docker
                sudo mkdir /workspace && cd /workspace
                sudo yum update -y
                sudo yum install -y docker
                sudo service docker start
                sudo usermod -a -G docker ec2-user

                # Fetch repo
                aws s3 cp s3://bandcloud/app/ud-conf.txt ./
                REGION=$(grep "region" ud-conf.txt | cut -d \= -f 2)
                REPO=$(grep "repo" ud-conf.txt | cut -d \= -f 2)
                PORT_VALS=$(grep "port" ud-conf.txt | cut -d \= -f 2)
                sudo echo -e "$REGION,$REPO,$PORT_VALS" > /workspace/sanity-check.txt
                $(aws ecr get-login-password --region $REGION) | docker login --username AWS --password-stdin $REPO &>> /workspace/sanity-check.txt
                docker pull $REPO &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p $PORT_VALS $REPO node app/dynamo-server.js &>> /workspace/webApplog-2.txt
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

                # Setup and install docker
                sudo mkdir /workspace && cd /workspace
                sudo yum update -y
                sudo yum install -y docker
                sudo service docker start
                sudo usermod -a -G docker ec2-user

                # Fetch repo
                aws s3 cp s3://bandcloud/app/ud-conf.txt ./
                REGION=$(grep "region" ud-conf.txt | cut -d \= -f 2)
                REPO=$(grep "repo" ud-conf.txt | cut -d \= -f 2)
                PORT_VALS=$(grep "port" ud-conf.txt | cut -d \= -f 2)
                sudo echo -e "${var.ecr_vars["region"]},${var.ecr_vars["repo"]},${var.ecr_vars["port"]} " > /workspace/sanity-check.txt
                $(aws ecr get-login-password --region ${var.ecr_vars["region"]}) | docker login --username AWS --password-stdin ${var.ecr_vars["repo"]} &>> /workspace/sanity-check.txt
                docker pull ${var.ecr_vars["repo"]} &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p ${var.ecr_vars["port"]} ${var.ecr_vars["repo"]} node app/dynamo-server.js &>> /workspace/webApplog-2.txt
                EOF
}