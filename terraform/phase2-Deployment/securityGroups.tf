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
resource "aws_security_group_rule" "httpAnywhere-in-fe-admin" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-admin-sg.id
    description = "http-anywhere-in"
}
resource "aws_security_group_rule" "httpAnywhere-out-fe-admin" {
    type = "egress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-admin-sg.id
    description = "http-anywhere-out"
}


# Permit ssh traffic
resource "aws_security_group_rule" "ssh-Anywhere-in-fe-admin" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-admin-sg.id
    description = "ssh-anywhere-in"
}
resource "aws_security_group_rule" "ssh-Anywhere-out-fe-admin" {
    type = "egress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-admin-sg.id
    description = "ssh-anywhere-out"
}


# ICMP
resource "aws_security_group_rule" "ping-Anywhere-in-fe-admin" {
    type = "ingress"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-admin-sg.id
    description = "ping-anywhere-in"
}
resource "aws_security_group_rule" "ping-Anywhere-out-fe-admin" {
    type = "egress"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-admin-sg.id
    description = "ping-anywhere-out"
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
resource "aws_security_group_rule" "app-httpAnywhere-in-fe" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-app-sg.id
    description = "http-anywhere-in"
}
resource "aws_security_group_rule" "app-httpAnywhere-out-fe" {
    type = "egress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-app-sg.id
    description = "http-anywhere-out"
}


# ICMP
resource "aws_security_group_rule" "app-ping-Anywhere-in-fe" {
    type = "ingress"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-app-sg.id
    description = "ping-anywhere"
}
resource "aws_security_group_rule" "app-ping-Anywhere-out-fe" {
    type = "egress"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ "0.0.0.0/0" ]
    security_group_id = aws_security_group.fe-app-sg.id
    description = "ping-anywhere-out"
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
resource "aws_security_group_rule" "httpLocal-in-be-admin" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ var.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "http-local-in"
}
resource "aws_security_group_rule" "httpLocal-out-be-admin" {
    type = "egress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ var.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "http-local-out"
}


# In/Outbound HTTPs
resource "aws_security_group_rule" "httpsLocal-in-be-admin" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ var.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "https-local-in"
}
resource "aws_security_group_rule" "httpsLocal-out-be-admin" {
    type = "egress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ var.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "https-local-out"
}


# Permit locl ssh traffic
resource "aws_security_group_rule" "ssh-Local-in-be-admin" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ var.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "ssh-local-in"
}
resource "aws_security_group_rule" "ssh-Local-out-be-admin" {
    type = "egress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ var.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "ssh-local-out"
}


# ICMP
resource "aws_security_group_rule" "ping-Local-in-be-admin" {
    type = "ingress"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ var.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "ping-local-in"
}
resource "aws_security_group_rule" "ping-Local-out-be-admin" {
    type = "egress"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ var.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "ping-local-out"
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
resource "aws_security_group_rule" "app-httpLocal-in" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ var.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-app-sg.id
    description = "app-http-local-in"
}
resource "aws_security_group_rule" "app-httpLocal-out" {
    type = "egress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ var.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-app-sg.id
    description = "app-http-local-out"
}


# In/Outbound HTTPs
resource "aws_security_group_rule" "app-httpsLocal" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ var.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-app-sg.id
    description = "app-https-local-in"
}
resource "aws_security_group_rule" "app-httpsLocal-out" {
    type = "egress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ var.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-admin-sg.id
    description = "https-local-out"
}


# ICMP
resource "aws_security_group_rule" "app-ping-Local-in" {
    type = "ingress"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ var.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-app-sg.id
    description = "app-ping-local-in"
}
resource "aws_security_group_rule" "app-ping-Local-out" {
    type = "egress"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ var.bandCloud-network.cidrBlock ]
    security_group_id = aws_security_group.be-app-sg.id
    description = "app-ping-local-out"
}