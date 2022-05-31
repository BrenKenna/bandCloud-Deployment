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
    type = map
    default = {
        iamRole  = "S3_Dynamo"
        key = "bandCloud"
        instanceType = "t2.micro"
        ami_1a = "ami-05be68f5425399abd"
        ami_1b = "ami-09aba1ee0015fc959"
    }
}