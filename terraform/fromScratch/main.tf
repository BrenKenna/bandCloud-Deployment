##################################################################
# 
# Frontend Spinup Instance in new VPC
#   - Intentionally making use of UD & variables.tf scoped vars 
# 
##################################################################

# Spin up example instance from image
resource "aws_instance" "frontend-test-1a" {
    ami = var.app_vars.appAMIs.az1a
    instance_type = var.app_vars.appInstanceType
    key_name = var.app_vars.appKey
    security_groups = [ aws_security_group.httpAnywhere.id ]
    iam_instance_profile  = var.app_vars.iamRole
    associate_public_ip_address = true
    subnet_id = aws_subnet.frontend-SubA.id
    
    tags = {
        Name = "frontend-test-1a"
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


# Zone 2
resource "aws_instance" "frontend-testing-1b" {
    ami = var.app_vars.appAMIs.az1a
    instance_type = var.app_vars.appInstanceType
    key_name = var.app_vars.appKey
    security_groups = [ aws_security_group.httpAnywhere.id ]
    iam_instance_profile  = var.app_vars.iamRole
    associate_public_ip_address = true
    subnet_id = aws_subnet.frontend-SubB.id
    tags = {
        Name = "frontend-test-1a"
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



##################################################################
# 
# Spinup Backend Sanity Check Servers
# 
##################################################################

# Spin up example instance from image
resource "aws_instance" "backend-test-1a" {
    ami = var.app_vars.appAMIs.az1a
    instance_type = var.app_vars.appInstanceType
    key_name = var.app_vars.appKey
    security_groups = [ aws_security_group.httpAnywhere.id ]
    iam_instance_profile  = var.app_vars.iamRole
    associate_public_ip_address = true
    subnet_id = aws_subnet.backend-SubA.id
    tags = {
        Name = "backend-test-1a"
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
                echo -e "${var.app_vars.region},${var.ecr_vars["repo"]},${var.app_vars.port} " > /workspace/sanity-check.txt
                $(aws ecr get-login-password --region ${var.ecr_vars["region"]} | docker login --username AWS --password-stdin ${var.app_vars.appRepos.frontend}) &>> /workspace/sanity-check.txt
                docker pull ${var.ecr_vars["repo"]} &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p ${var.app_vars.port} ${var.app_vars.appRepos.backend} java -jar libs/service_testing-0.0.1.jar &>> /workspace/webApplog.txt
                EOF
}


# Zone 2
resource "aws_instance" "backend-test-1b" {
    ami = var.app_vars.appAMIs.az1a
    instance_type = var.app_vars.appInstanceType
    key_name = var.app_vars.appKey
    security_groups = [ aws_security_group.httpAnywhere.id ]
    iam_instance_profile  = var.app_vars.iamRole
    associate_public_ip_address = true
    subnet_id = aws_subnet.backend-SubB.id
    tags = {
        Name = "backend-test-1b"
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
                echo -e "${var.app_vars.region},${var.ecr_vars["repo"]},${var.app_vars.port} " > /workspace/sanity-check.txt
                $(aws ecr get-login-password --region ${var.ecr_vars["region"]} | docker login --username AWS --password-stdin ${var.app_vars.appRepos.frontend}) &>> /workspace/sanity-check.txt
                docker pull ${var.ecr_vars["repo"]} &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p ${var.app_vars.port} ${var.app_vars.appRepos.backend} java -jar libs/service_testing-0.0.1.jar &>> /workspace/webApplog.txt
                EOF
}