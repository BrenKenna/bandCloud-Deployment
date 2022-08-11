# Network config as object
variable "bandCloud-network" {
    description = "Object to hold network configurations for front & backed AZs"
    type = object({
        vpcName = string
        cidrBlock = string
        region = string

        az1_subnets = object({
            availZone = string 
            frontend = string
            backend = string
        })

        az2_subnets = object({
            availZone = string 
            frontend = string
            backend = string
        })
    })

    default = {
      az1_subnets = {
          "availZone": "eu-west-1a",
          "frontend": "192.168.1.0/24",
          "backend": "192.168.2.0/24"
      }
      az2_subnets = {
          "availZone": "eu-west-1b",
          "frontend": "192.168.3.0/24",
          "backend": "192.168.4.0/24"
      }
      cidrBlock = "192.168.0.0/16"
      region = "eu-west-1"
      vpcName = "bandCloud-VPC"
    }
}


# Object for running apps
variable "app_vars" {
    description = "Object to hold variables for running Front & Backend Apps"
    type = object({
        iamRole = string
        appInstanceType = string
        appKey = string
        region = string
        port = string
        appAMIs = object({
            az1a = string
            az1b = string
        })
        appRepos = object({
            frontend = string
            backend = string
        })
    })

    default = {
      iamRole = "S3_Dynamo"
      appKey = "bandCloud"
      appInstanceType = "t2.micro"
      region = "eu-west-1"
      port = "8080:8080"
      appRepos = {
          "loginApp": "017511708259.dkr.ecr.eu-west-1.amazonaws.com/bandcloud",
          "springApp": "017511708259.dkr.ecr.eu-west-1.amazonaws.com/bandcloud-backend",
          "backend": "017511708259.dkr.ecr.eu-west-1.amazonaws.com/spring-backend",
          "frontend": "017511708259.dkr.ecr.eu-west-1.amazonaws.com/bandcloud-frontend"
      }
      appAMIs = {
          "az1a" = "ami-05be68f5425399abd",
          "az1b" = "ami-09aba1ee0015fc959"
      }
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