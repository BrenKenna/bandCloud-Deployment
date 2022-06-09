####################################
# 
# Frontend Launch Configuration & ASG
# 
####################################

# Launch config
resource "aws_launch_configuration" "frontend-LC-1a" {
    name = "frontend-app-1a"
    image_id = var.app_vars.appAMIs.az1a
    instance_type = var.app_vars.appInstanceType
    key_name = var.app_vars.appKey
    security_groups = [ aws_security_group.httpAnywhere.id ]
    iam_instance_profile  = var.app_vars.iamRole
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
                echo -e "$REGION,$REPO,$PORT_VALS" > /workspace/sanity-check.txt
                $(aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REPO) &>> /workspace/sanity-check.txt
                docker pull $REPO &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p $PORT_VALS $REPO bash app/launchServer.sh $REGION &>> /workspace/webApplog.txt
                EOF
}


###########################
# 
# Second subnet
# 
###########################

resource "aws_launch_configuration" "frontend-LC-1b" {
    name = "frontend-app-1b"
    image_id = var.app_vars.appAMIs.az1b
    instance_type = var.app_vars.appInstanceType
    key_name = var.app_vars.appKey
    security_groups = [ aws_security_group.httpAnywhere.id ]
    iam_instance_profile  = var.app_vars.iamRole
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
                echo -e "${var.ecr_vars["region"]},${var.ecr_vars["repo"]},${var.ecr_vars["port"]} " > /workspace/sanity-check.txt
                $(aws ecr get-login-password --region ${var.ecr_vars["region"]} | docker login --username AWS --password-stdin ${var.ecr_vars["repo"]}) &>> /workspace/sanity-check.txt
                docker pull ${var.ecr_vars["repo"]} &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p ${var.ecr_vars["port"]} ${var.ecr_vars["repo"]} bash app/launchServer.sh ${var.ecr_vars["region"]} &>> /workspace/webApplog.txt
                EOF
}



####################################
# 
# Backend Launch Configuration & ASG
# 
####################################

# Launch config
resource "aws_launch_configuration" "backend-LC-1a" {
    name = "backend-app-1a"
    image_id = var.app_vars.appAMIs.az1a
    instance_type = var.app_vars.appInstanceType
    key_name = var.app_vars.appKey
    security_groups = [ aws_security_group.httpAnywhere.id ]
    iam_instance_profile  = var.app_vars.iamRole
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
                echo -e "${var.app_vars.region},${var.ecr_vars["repo"]},${var.app_vars.port} " > /workspace/sanity-check.txt
                $(aws ecr get-login-password --region ${var.ecr_vars["region"]} | docker login --username AWS --password-stdin ${var.app_vars.appRepos.frontend}) &>> /workspace/sanity-check.txt
                docker pull ${var.ecr_vars["repo"]} &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p ${var.app_vars.port} ${var.app_vars.appRepos.backend} java -jar libs/service_testing-0.0.1.jar &>> /workspace/webApplog.txt
                EOF
}


###########################
# 
# Second subnet
# 
###########################

resource "aws_launch_configuration" "backend-LC-1b" {
    name = "backend-app-1b"
    image_id = var.app_vars.appAMIs.az1b
    instance_type = var.app_vars.appInstanceType
    key_name = var.app_vars.appKey
    security_groups = [ aws_security_group.httpAnywhere.id ]
    iam_instance_profile  = var.app_vars.iamRole
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
                echo -e "${var.app_vars.region},${var.ecr_vars["repo"]},${var.app_vars.port} " > /workspace/sanity-check.txt
                $(aws ecr get-login-password --region ${var.ecr_vars["region"]} | docker login --username AWS --password-stdin ${var.app_vars.appRepos.frontend}) &>> /workspace/sanity-check.txt
                docker pull ${var.ecr_vars["repo"]} &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p ${var.app_vars.port} ${var.app_vars.appRepos.backend} java -jar libs/service_testing-0.0.1.jar &>> /workspace/webApplog.txt
                EOF
}