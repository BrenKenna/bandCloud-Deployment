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

# External traffic rules
resource "aws_security_group" "fe-external-dev" {
    name = "http-external-dev"
    vpc_id = aws_vpc.bandCloud-VPC.id
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "http-dev-external-in"
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "ssh-external-in"
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "http-external-in"
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "https-external-in"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "all-external-out"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "::0/0" ]
        description = "all-ipv6-external-out"
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


# Local traffic rules
resource "aws_security_group" "be-internal-dev" {
    name = "https-internal"
    vpc_id = aws_vpc.bandCloud-VPC.id
    ingress{
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [ "${var.bandCloud-network.cidrBlock}" ]
        description = "https-internal-in"
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "${var.bandCloud-network.cidrBlock}" ]
        description = "ssh-internal-in"
    }

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
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "all-internal-out"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "::0/0" ]
        description = "all-ipv6-external-out"
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