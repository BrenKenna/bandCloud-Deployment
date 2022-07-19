############################################################################################
# 
# Frontend Spinup Instance in new VPC
#   - Intentionally making use of UD & variables.tf scoped vars 
#   - The purpose of these servers is to be able to sanity check deployment issues
#       - Port 22 is intentionally exposed for this reason
#       - There is one per AZ as a "just in case" for unseen issues.
#           => Doubtless there are services to help here, but that stuff comes laterzz :)
# 
#############################################################################################

# Spin up example instance from image
resource "aws_instance" "frontend-test-1a" {
    ami = var.app_vars.appAMIs.az1a
    instance_type = var.app_vars.appInstanceType
    key_name = var.app_vars.appKey
    security_groups = [ aws_security_group.fe-external-dev.id ]
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
                echo -e "${var.app_vars.region},${var.app_vars.appRepos.frontend},${var.app_vars.port} " > /workspace/sanity-check.txt
                $(aws ecr get-login-password --region ${var.app_vars.region} | docker login --username AWS --password-stdin ${var.app_vars.appRepos.frontend}) &>> /workspace/sanity-check.txt
                docker pull ${var.app_vars.appRepos.frontend} &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p ${var.app_vars.port} ${var.app_vars.appRepos.frontend} bash launchServer.sh ${var.app_vars.region} &>> /workspace/webApplog.txt
                EOF
}


# Zone 2
resource "aws_instance" "frontend-testing-1b" {
    ami = var.app_vars.appAMIs.az1a
    instance_type = var.app_vars.appInstanceType
    key_name = var.app_vars.appKey
    security_groups = [ aws_security_group.fe-external-dev.id ]
    iam_instance_profile  = var.app_vars.iamRole
    associate_public_ip_address = true
    subnet_id = aws_subnet.frontend-SubB.id
    tags = {
        Name = "frontend-test-1b"
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
                echo -e "${var.app_vars.region},${var.app_vars.appRepos.frontend},${var.app_vars.port} " > /workspace/sanity-check.txt
                $(aws ecr get-login-password --region ${var.app_vars.region} | docker login --username AWS --password-stdin ${var.app_vars.appRepos.frontend}) &>> /workspace/sanity-check.txt
                docker pull ${var.app_vars.appRepos.frontend} &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p ${var.app_vars.port} ${var.app_vars.appRepos.frontend} bash launchServer.sh ${var.app_vars.region} &>> /workspace/webApplog.txt
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
    security_groups = [ aws_security_group.be-internal-dev.id ]
    iam_instance_profile  = var.app_vars.iamRole
    associate_public_ip_address = false
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
                $(aws ecr get-login-password --region ${var.ecr_vars["region"]} | docker login --username AWS --password-stdin ${var.app_vars.appRepos.backend}) &>> /workspace/sanity-check.txt
                docker pull ${var.app_vars.appRepos.backend} &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p ${var.app_vars.port} ${var.app_vars.appRepos.backend} java -jar libs/service_testing-0.0.1.jar &>> /workspace/webApplog.txt
                EOF
}


# Zone 2
resource "aws_instance" "backend-test-1b" {
    ami = var.app_vars.appAMIs.az1a
    instance_type = var.app_vars.appInstanceType
    key_name = var.app_vars.appKey
    security_groups = [ aws_security_group.be-internal-dev.id ]
    iam_instance_profile  = var.app_vars.iamRole
    associate_public_ip_address = false
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
                $(aws ecr get-login-password --region ${var.ecr_vars["region"]} | docker login --username AWS --password-stdin ${var.app_vars.appRepos.backend}) &>> /workspace/sanity-check.txt
                docker pull ${var.app_vars.appRepos.backend} &>> /workspace/sanity-check.txt

                # Run container
                docker run -d -p ${var.app_vars.port} ${var.app_vars.appRepos.backend} java -jar libs/service_testing-0.0.1.jar &>> /workspace/webApplog.txt
                EOF
}