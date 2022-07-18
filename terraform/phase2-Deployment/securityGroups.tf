######################################
# 
# Create Frontend Security Groups
# 
######################################

########################
# 
# Admin
# 
########################

# Admin fe-SG
resource "aws_security_group" "fe-admin-sg" {
  name = "fe-admin-sg"
  vpc_id = aws_vpc.bandCloud-VPC.id
}


# In/Outbound HTTP-Dev
resource "aws_security_group_rule" "httpAnywhere" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-admin-sg.id
    description = "http-anywhere"
}
resource "aws_security_group_rule" "httpAnywhere" {
    type = "egress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-admin-sg.id
    description = "http-anywhere"
}


# Permit ssh traffic
resource "aws_security_group_rule" "ssh-Anywhere" {
    type = "egress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-admin-sg.id
    description = "http-anywhere"
}
resource "aws_security_group_rule" "ssh-Anywhere" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-admin-sg.id
    description = "http-anywhere"
}


# ICMP
resource "aws_security_group_rule" "ping-Anywhere" {
    type = "ingress"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-admin-sg.id
    description = "ping-anywhere"
}
resource "aws_security_group_rule" "ping-Anywhere" {
    type = "egress"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-admin-sg.id
    description = "ping-anywhere"
}


########################
# 
# Frontend Application
# 
########################


# Application fe-SG
resource "aws_security_group" "fe-app-sg" {
  name = "fe-app-sg"
  vpc_id = aws_vpc.bandCloud-VPC.id
}


# In/Outbound HTTP-Dev
resource "aws_security_group_rule" "httpAnywhere" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-app-sg.id
    description = "http-anywhere"
}
resource "aws_security_group_rule" "httpAnywhere" {
    type = "egress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-app-sg.id
    description = "http-anywhere"
}


# ICMP
resource "aws_security_group_rule" "ping-Anywhere" {
    type = "ingress"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-app-sg.id
    description = "ping-anywhere"
}
resource "aws_security_group_rule" "ping-Anywhere" {
    type = "egress"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-app-sg.id
    description = "ping-anywhere"
}



###################################
###################################
# 
# Backend Security Groups
# 
###################################
###################################


########################
# 
# Admin
# 
########################

# Admin be-SG
resource "aws_security_group" "be-admin-sg" {
  name = "be-admin-sg"
  vpc_id = aws_vpc.bandCloud-VPC.id
}


# In/Outbound HTTP
resource "aws_security_group_rule" "httpLocal" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ vars.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "http-local"
}
resource "aws_security_group_rule" "httpLocal" {
    type = "egress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ vars.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "http-local"
}


# In/Outbound HTTPs
resource "aws_security_group_rule" "httpsLocal" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ vars.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "https-local"
}
resource "aws_security_group_rule" "httpsLocal" {
    type = "egress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ vars.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "https-local"
}


# Permit locl ssh traffic
resource "aws_security_group_rule" "ssh-Local" {
    type = "egress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ vars.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "ssh-local"
}
resource "aws_security_group_rule" "ssh-Local" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ vars.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "ssh-local"
}


# ICMP
resource "aws_security_group_rule" "ping-Local" {
    type = "ingress"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ vars.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "ping-local"
}
resource "aws_security_group_rule" "ping-Local" {
    type = "egress"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ vars.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "ping-local"
}


########################
# 
# Backend Application
# 
########################


# Application be-SG
resource "aws_security_group" "be-app-sg" {
  name = "be-app-sg"
  vpc_id = aws_vpc.bandCloud-VPC.id
}







#################################
# 
# Local Traffic
# 
#################################

# Permit local http
resource "aws_security_group" "local-http" {
    name = "local-http"
    vpc_id = aws_vpc.bandCloud-VPC.id
    tags = {
        Name = "local-http"
    }

    # Allow inbound
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [ vars.bandCloud-network.cidrBlock ]
    }

    # Allow outbound
    egress {
        from_port = 8080
        to_port = 8080
        protocol = "-1"
        cidr_blocks = [ vars.bandCloud-network.cidrBlock ]
    }
}

# SSh
resource "aws_security_group" "local-ssh" {
    name = "local-ssh"
    vpc_id = aws_vpc.bandCloud-VPC.id
    tags = {
        Name = "local-ssh"
    }

    # Allow inbound
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ vars.bandCloud-network.cidrBlock ]
    }

    # Allow outbound
    egress {
        from_port = 22
        to_port = 22
        protocol = "-1"
        cidr_blocks = [ vars.bandCloud-network.cidrBlock ]
    }
}


# ICMP
resource "aws_security_group" "local-ping" {
    name = "local-ping"
    vpc_id = aws_vpc.bandCloud-VPC.id
    tags = {
        Name = "local-ping"
    }

    # Allow inbound
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [ vars.bandCloud-network.cidrBlock ]
    }

    # Allow outbound
    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [ vars.bandCloud-network.cidrBlock ]
    }
}