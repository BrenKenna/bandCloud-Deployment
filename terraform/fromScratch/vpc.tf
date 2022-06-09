##########################################
# 
# Configure VPC and Public Subnets
# 
##########################################


# Configure VPC
resource "aws_vpc" "bandCloud-VPC" {
    cidr_block = var.bandCloud-network.cidrBlock
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = var.bandCloud-network.vpcName
    }
}


######################
# 
# AZ-1 Subnets
# 
######################

# Configure frontend subnet
resource "aws_subnet" "frontend-SubA" {
    vpc_id = aws_vpc.bandCloud-VPC.id
    cidr_block = var.bandcloud-network.az1_subnets.frontend
    availability_zone = var.bandcloud-network.az1_subnets.availZone
    map_public_ip_on_launch = true
    tags = {
        Name = "frontend-SubA"
    }
    depends_on = [ aws_vpc.bandCloud-VPC ]
}


# Configure backend subnet
resource "aws_subnet" "backend-SubA" {
    vpc_id = aws_vpc.bandCloud-VPC.id
    cidr_block = var.bandcloud-network.az1_subnets.backend
    availability_zone = var.bandcloud-network.az1_subnets.availZone
    map_public_ip_on_launch = true
    tags = {
        Name = "backend-SubA"
    }
    depends_on = [ aws_vpc.bandCloud-VPC ]
}


######################
# 
# AZ-2 Subnets
# 
######################

# Configure frontend subnet
resource "aws_subnet" "frontend-SubB" {
    vpc_id = aws_vpc.bandCloud-VPC.id
    cidr_block = var.bandcloud-network.az2_subnets.frontend
    availability_zone = var.bandcloud-network.az2_subnets.availZone
    map_public_ip_on_launch = true
    tags = {
        Name = "frontend-SubB"
    }
    depends_on = [ aws_vpc.bandCloud-VPC ]
}


# Configure backend subnet
resource "aws_subnet" "backend-SubB" {
    vpc_id = aws_vpc.bandCloud-VPC.id
    cidr_block = var.bandcloud-network.az2_subnets.backend
    availability_zone = var.bandcloud-network.az2_subnets.availZone
    map_public_ip_on_launch = true
    tags = {
        Name = "backend-SubBs"
    }
    depends_on = [ aws_vpc.bandCloud-VPC ]
}