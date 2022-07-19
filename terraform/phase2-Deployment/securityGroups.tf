###################################################
###################################################
# 
# Create Security Groups for In/External Traffic
# 
###################################################
###################################################

########################
# 
# External
# 
########################

# Allow external HTTP traffic
resource "aws_security_group" "http-external-dev" {
    name = "http-external-dev"
    vpc_id = aws_vpc.bandCloud-VPC.id
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "http-external-in"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "http-external-out"
    }
}


# Allow external ssh traffic
resource "aws_security_group" "ssh-external" {
    name = "ssh-external"
    vpc_id = aws_vpc.bandCloud-VPC.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "ssh-external-in"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "ssh-external-out"
    }
}


/*
# Allow external ICMP traffic
resource "aws_security_group" "ping-external" {
    name = "ping-external"
    vpc_id = aws_vpc.bandCloud-VPC.id
    ingress {
        from_port = -1
        to_port = -1
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "ping-external-in"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "ping-external-out"
    }
}
*/

###################################
###################################
# 
# Local Traffic
# 
###################################
###################################

# Allow local HTTP traffic
resource "aws_security_group" "http-internal-dev" {
    name = "http-internal-dev"
    vpc_id = aws_vpc.bandCloud-VPC.id
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [ "${var.bandCloud-network.cidrBlock}" ]
        description = "http-internal-in"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "${var.bandCloud-network.cidrBlock}" ]
        description = "http-internal-out"
    }
}


# Permit locl ssh traffic
resource "aws_security_group" "ssh-internal" {
    name = "ssh-internal"
    vpc_id = aws_vpc.bandCloud-VPC.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "${var.bandCloud-network.cidrBlock}" ]
        description = "ssh-internal-in"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "${var.bandCloud-network.cidrBlock}" ]
        description = "ssh-internal-out"
    }
}


/*
# ICMP
resource "aws_security_group" "ping-internal" {
    name = "ping-internal"
    vpc_id = aws_vpc.bandCloud-VPC.id
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [ "${var.bandCloud-network.cidrBlock}" ]
        description = "ping-internal-in"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "${var.bandCloud-network.cidrBlock}" ]
        description = "ping-internal-out"
    }
}
*/

# Allow HTTPs
resource "aws_security_group" "https-internal" {
    name = "https-internal"
    vpc_id = aws_vpc.bandCloud-VPC.id
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [ "${var.bandCloud-network.cidrBlock}" ]
        description = "https-internal-in"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "${var.bandCloud-network.cidrBlock}" ]
        description = "https-internal-out"
    }
}