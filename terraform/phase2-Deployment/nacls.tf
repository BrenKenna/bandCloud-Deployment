#################################################
#################################################
# 
# Public & Private Network Access Control List
# 
#################################################
#################################################


####################################
# 
# Admin NACLs
# 
####################################


###############################
#
# Create fe-admin-nacl
#
###############################


# Create nacl
resource "aws_network_acl" "fe-admin-nacl" {
    vpc_id = aws_vpc.bandCloud-VPC.id
    subnet_ids = [ aws_subnet.frontend-SubA.id, aws_subnet.frontend-SubB.id ]
    tags = {
        Name = "bandCloud-fe-admin-nacl"
    }
}

# Allow in/outbound ssh
resource "aws_network_acl_rule" "inbound_ssh" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 100
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 22
    to_port = 22
}
resource "aws_network_acl_rule" "outbound_ssh" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 100
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 22
    to_port = 22
}

# Allow http-8080
resource "aws_network_acl_rule" "inbound_http" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 110
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 8080
    to_port = 8080
}
resource "aws_network_acl_rule" "outbound_http" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 110
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 8080
    to_port = 8080
}


# Allow ping
resource "aws_network_acl_rule" "inbound_ping" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 120
    egress = false
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
}
resource "aws_network_acl_rule" "outbound_ping" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 120
    egress = true
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
}


###############################
#
# Create backend admin-nacl
#
###############################


# Create nacl
resource "aws_network_acl" "be-admin-nacl" {
    vpc_id = aws_vpc.bandCloud-VPC.id
    subnet_ids = [ aws_subnet.backend-SubA.id, aws_subnet.backend-SubB.id ]
    tags = {
        Name = "bandCloud-be-admin-nacl"
    }
}

# Allow in/outbound ssh
resource "aws_network_acl_rule" "inbound_ssh" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 100
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "${vars.bandCloud-network.cidrBlock}"
    from_port = 22
    to_port = 22
}
resource "aws_network_acl_rule" "outbound_ssh" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 100
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "${vars.bandCloud-network.cidrBlock}"
    from_port = 22
    to_port = 22
}


# Allow http-8080-Dev
resource "aws_network_acl_rule" "inbound_http" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 110
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "${vars.bandCloud-network.cidrBlock}"
    from_port = 8080
    to_port = 8080
}
resource "aws_network_acl_rule" "outbound_http" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 110
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "${vars.bandCloud-network.cidrBlock}"
    from_port = 8080
    to_port = 8080
}


# Allow ping
resource "aws_network_acl_rule" "inbound_ping" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 120
    egress = false
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "${vars.bandCloud-network.cidrBlock}"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
}
resource "aws_network_acl_rule" "outbound_ping" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 120
    egress = true
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "${vars.bandCloud-network.cidrBlock}"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
}


# Outbound https
resource "aws_network_acl_rule" "outbound_https" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 130
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 443
    to_port = 443
}


####################################
# 
# Application NACLs
# 
####################################


##################################
#
# Create fe-application-nacl
#
#################################


# Create nacl
resource "aws_network_acl" "fe-app-nacl" {
    vpc_id = aws_vpc.bandCloud-VPC.id
    subnet_ids = [ aws_subnet.frontend-SubA.id, aws_subnet.frontend-SubB.id ]
    tags = {
        Name = "bandCloud-fe-app-nacl"
    }
}


# Allow http-8080
resource "aws_network_acl_rule" "inbound_http" {
    network_acl_id = aws_network_acl.fe-app-nacl.id
    rule_number = 100
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 8080
    to_port = 8080
}
resource "aws_network_acl_rule" "outbound_http" {
    network_acl_id = aws_network_acl.fe-app-nacl.id
    rule_number = 100
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 8080
    to_port = 8080
}


# Allow ping
resource "aws_network_acl_rule" "inbound_ping" {
    network_acl_id = aws_network_acl.fe-app-nacl.id
    rule_number = 110
    egress = false
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
}
resource "aws_network_acl_rule" "outbound_ping" {
    network_acl_id = aws_network_acl.fe-app-nacl.id
    rule_number = 120
    egress = true
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
}


###############################
#
# Create backend admin-nacl
#
###############################


# Create nacl
resource "aws_network_acl" "be-app-nacl" {
    vpc_id = aws_vpc.bandCloud-VPC.id
    subnet_ids = [ aws_subnet.backend-SubA.id, aws_subnet.backend-SubB.id ]
    tags = {
        Name = "bandCloud-be-app-nacl"
    }
}


# Allow http-8080
resource "aws_network_acl_rule" "inbound_http" {
    network_acl_id = aws_network_acl.be-app-nacl.id
    rule_number = 100
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "${vars.bandCloud-network.cidrBlock}"
    from_port = 8080
    to_port = 8080
}
resource "aws_network_acl_rule" "outbound_http" {
    network_acl_id = aws_network_acl.be-app-nacl.id
    rule_number = 100
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "${vars.bandCloud-network.cidrBlock}"
    from_port = 8080
    to_port = 8080
}


# Allow ping
resource "aws_network_acl_rule" "inbound_ping" {
    network_acl_id = aws_network_acl.be-app-nacl.id
    rule_number = 110
    egress = false
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "${vars.bandCloud-network.cidrBlock}"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
}
resource "aws_network_acl_rule" "outbound_ping" {
    network_acl_id = aws_network_acl.be-app-nacl.id
    rule_number = 110
    egress = true
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "${vars.bandCloud-network.cidrBlock}"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
}


# Allow https out
resource "aws_network_acl_rule" "outbound_https" {
    network_acl_id = aws_network_acl.be-app-nacl.id
    rule_number = 120
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 443
    to_port = 443
}