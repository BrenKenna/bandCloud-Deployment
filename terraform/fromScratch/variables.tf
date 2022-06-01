# Map for the app network
variable "tf_network" {
    type = map
    default = {
        cidrBlock = "10.2.0.0/16"
        publicSubnet_A = "10.2.1.0/24"
        publicSubnet_B = "10.2.2.0/24"
        availZone_A = "eu-west-1a"
        availZone_B = "eu-west-1b"
    }
}


# Map for instance variables
variable "ec2_vars" {
    description = "Map of core standard variables for EC2"
    type = map
    default = {
        iamRole  = "S3_Dynamo"
        key = "bandCloud"
        instanceType = "t2.micro"
        ami_1a = "ami-05be68f5425399abd"
        ami_1b = "ami-09aba1ee0015fc959"
    }
}


# ECR
variable "ecr_vars" {
    description = "Map of core variables for ECR"
    type = map
    default = {
        region = "eu-west-1"
        port = "8080:8080"
        repo = "017511708259.dkr.ecr.eu-west-1.amazonaws.com/bandcloud"
    }
}