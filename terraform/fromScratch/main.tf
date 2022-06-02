##################################################################
# 
# Spinup Instance in new VPC
#   - Intentionally making use of UD & variables.tf scoped vars 
# 
##################################################################

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
                echo -e "$REGION,$REPO,$PORT_VALS" > /workspace/sanity-check.txt
                $(aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REPO) &>> /workspace/sanity-check.txt
                docker pull $REPO &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p $PORT_VALS $REPO bash app/launchServer.sh $REGION &>> /workspace/webApplog.txt
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

                # Setup and install docker
                sudo mkdir /workspace && cd /workspace
                sudo yum update -y
                sudo yum install -y docker
                sudo service docker start
                sudo usermod -a -G docker ec2-user

                # Fetch repo
                echo -e "${var.ecr_vars["region"]},${var.ecr_vars["repo"]},${var.ecr_vars["port"]} " > /workspace/sanity-check.txt
                $(aws ecr get-login-password --region ${var.ecr_vars["region"]} | docker login --username AWS --password-stdin ${var.ecr_vars["repo"]}) &>> /workspace/sanity-check.txt
                docker pull ${var.ecr_vars["repo"]} &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p ${var.ecr_vars["port"]} ${var.ecr_vars["repo"]} bash app/launchServer.sh ${var.ecr_vars["region"]} &>> /workspace/webApplog.txt
                EOF
}