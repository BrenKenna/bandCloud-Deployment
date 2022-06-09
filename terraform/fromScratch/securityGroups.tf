######################################
# 
# Security Groups
# 
######################################

# (In)Outbound HTTP to anywhere
resource "aws_security_group" "httpAnywhere" {
    name = "http-anywhere"
    vpc_id = aws_vpc.bandCloud-VPC.id
    tags = {
        Name = "http-anywhere"
    }

    # Allow inbound
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    # Allow outbound
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}


# Permit ssh traffic
resource "aws_security_group" "sg22" {
    name = "sg22"
    vpc_id = aws_vpc.terraformVPC.id
    tags = {
        Name = "sg-22"
    }

    # Allow inbound
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    # Allow outbound
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}