#######################################
# 
# Consider tutorials use of objects
# 
######################################

# VPC
variable "bandCloudVPC" {
    type = map
    default = {
        id = "vpc-017359c9e6b2a1943"
        netACL = "acl-0499de4e2f15e6018"
        routePub = "rtb-033b1991783b995c9"
        routePriv = "rtb-0ee363c062d6d506f"
        igw = "igw-0462462fa9bdcbad1"
        key = "bandCloud"
    }
    
}


# Public subnets
variable pubSub {
    type = map
    default = {
        sgID = "sg-06b817d33a234df6d"
        ami = "ami-0f19be2c806fdccf7"
        instanceName = "terraFormTesting"
        iamRole  = "S3_Dynamo"
    }
}
variable "publicSubnet_a" {
    type = map
    default = {
        id = "subnet-0a79a989caf68c030"
        aZ = "eu-west-1a"
    }
}
variable "publicSubnet_b" {
    type = map
    default = {
        id = "subnet-0408f97b2a00beaa0"
        aZ = "eu-west-1c"
    }
}


# Private subnets
variable "privateSubnet_a" {
    type = map
    default = {
        id = "subnet-083b9974c2465a5d5"
        aZ = "eu-west-1a"
    }
}
variable "privateSubnet_b" {
    type = map
    default = {
        id = "subnet-06f7f5fc9136d3b28"
        aZ = "eu-west-1c"
    }
}
