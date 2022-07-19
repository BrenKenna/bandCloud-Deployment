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
    security_groups = [ aws_security_group.fe-external-dev.id ]
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
                echo -e "${var.app_vars.region},${var.app_vars.appRepos.frontend},${var.app_vars.port} " > /workspace/sanity-check.txt
                $(aws ecr get-login-password --region ${var.app_vars.region} | docker login --username AWS --password-stdin ${var.app_vars.appRepos.frontend}) &>> /workspace/sanity-check.txt
                docker pull ${var.app_vars.appRepos.frontend} &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p ${var.app_vars.port} ${var.app_vars.appRepos.frontend} bash launchServer.sh ${var.app_vars.region} &>> /workspace/webApplog.txt
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
    security_groups = [ aws_security_group.fe-external-dev.id ]
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
                echo -e "${var.app_vars.region},${var.app_vars.appRepos.frontend},${var.app_vars.port} " > /workspace/sanity-check.txt
                $(aws ecr get-login-password --region ${var.app_vars.region} | docker login --username AWS --password-stdin ${var.app_vars.appRepos.frontend}) &>> /workspace/sanity-check.txt
                docker pull ${var.app_vars.appRepos.frontend} &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p ${var.app_vars.port} ${var.app_vars.appRepos.frontend} bash launchServer.sh ${var.app_vars.region} &>> /workspace/webApplog.txt
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
    security_groups = [ aws_security_group.be-internal-dev.id ]
    iam_instance_profile  = var.app_vars.iamRole
    associate_public_ip_address = false
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
                $(aws ecr get-login-password --region ${var.ecr_vars["region"]} | docker login --username AWS --password-stdin ${var.app_vars.appRepos.backend}) &>> /workspace/sanity-check.txt
                docker pull ${var.app_vars.appRepos.backend} &>> /workspace/sanity-check.txt

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
    security_groups = [ aws_security_group.be-internal-dev.id ]
    iam_instance_profile  = var.app_vars.iamRole
    associate_public_ip_address = false
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
                $(aws ecr get-login-password --region ${var.ecr_vars["region"]} | docker login --username AWS --password-stdin ${var.app_vars.appRepos.backend}) &>> /workspace/sanity-check.txt
                docker pull ${var.app_vars.appRepos.backend} &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p ${var.app_vars.port} ${var.app_vars.appRepos.backend} java -jar libs/service_testing-0.0.1.jar &>> /workspace/webApplog.txt
                EOF
}