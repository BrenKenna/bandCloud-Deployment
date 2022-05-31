# Map for the app network
variable "tf_network" {
    type = map
    default = {
        cidrBlock = "11.1.0.0/16"
        publicSubnet_A = "11.1.0.0/24"
        publicSubnet_B = "11.1.1.0/24"
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
    }
}