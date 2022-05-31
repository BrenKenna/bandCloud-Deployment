##########################################
# 
# Configure VPC and Public Subnets
# 
##########################################


# Configure VPC
resource "aws_vpc" "terraformVPC" {
    cidr_block = var.tf_network["cidrBlock"]
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "terraform-vpc"
    }
}


# Configure public subnet in AZ-A
resource "aws_subnet" "pubSub_A" {
    vpc_id = aws_vpc.terraformVPC.id
    cidr_block = var.tf_network["publicSubnet_A"]
    availability_zone = var.tf_network["availZone_A"]
    map_public_ip_on_launch = true
    tags = {
        Name = "terraform-PubSub-A"
    }
    depends_on = [ aws_vpc.terraformVPC ]
}


# Configure backup
resource "aws_subnet" "pubSub_B" {
    vpc_id = aws_vpc.terraformVPC.id
    cidr_block = var.tf_network["publicSubnet_B"]
    availability_zone = var.tf_network["availZone_B"]
    map_public_ip_on_launch = true
    enable_resource_name_dns_a_record_on_launch = true
    tags = {
        Name = "terraform-PubSub-B"
    }
    depends_on = [ aws_vpc.terraformVPC ]
}