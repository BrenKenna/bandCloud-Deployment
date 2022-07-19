########################################################
########################################################
# 
# Public & Private Network Access Control List
#
# Had to add a rule for 1024-65355 for enabling ssh etc
#   -> Should be an approachable to close down, 
#       but nice to know its functional at least
#   -> Since the NAT-Gateway is in the PubSub-A, web
#       traffic from Priv-Subs should be allowed + ephem
# 
#########################################################
#########################################################


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
        Name = "fe-admin-nacl"
    }
}

# Allow in/outbound ssh
resource "aws_network_acl_rule" "inbound_ssh-fe-admin" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 100
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 22
    to_port = 22
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}
resource "aws_network_acl_rule" "outbound_ssh-fe-admin" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 100
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 22
    to_port = 22
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}

# Allow http-8080
resource "aws_network_acl_rule" "inbound_http-fe-admin" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 110
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 8080
    to_port = 8080
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}
resource "aws_network_acl_rule" "outbound_http-fe-admin" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 110
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 8080
    to_port = 8080
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}


# Allow ping
resource "aws_network_acl_rule" "inbound_ping-fe-admin" {
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
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}
resource "aws_network_acl_rule" "outbound_ping-fe-admin" {
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
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}

# Allow emphemeral
resource "aws_network_acl_rule" "inbound_emphem-fe-admin" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 130
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}
resource "aws_network_acl_rule" "outbound_emphem-fe-admin" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 130
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}


# Allow HTTPs traffic
resource "aws_network_acl_rule" "inbound_https-fe-admin" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 140
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}

resource "aws_network_acl_rule" "outbound_https-fe-admin" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 140
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}


# Allow HTTP traffic
resource "aws_network_acl_rule" "inbound_http-norm-fe-admin" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 150
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}

resource "aws_network_acl_rule" "outbound_http-norm-fe-admin" {
    network_acl_id = aws_network_acl.fe-admin-nacl.id
    rule_number = 150
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
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
        Name = "be-admin-nacl"
    }
}

# Allow in/outbound ssh
resource "aws_network_acl_rule" "inbound_ssh-be-admin" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 100
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "${var.bandCloud-network.cidrBlock}"
    from_port = 22
    to_port = 22
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}
resource "aws_network_acl_rule" "outbound_ssh-be-admin" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 100
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 22
    to_port = 22
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}


# Allow http-8080-Dev
resource "aws_network_acl_rule" "inbound_http-be-admin" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 110
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "${var.bandCloud-network.cidrBlock}"
    from_port = 8080
    to_port = 8080
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}
resource "aws_network_acl_rule" "outbound_http-be-admin" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 110
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 8080
    to_port = 8080
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}


# Allow ping
resource "aws_network_acl_rule" "inbound_ping-be-admin" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 120
    egress = false
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "${var.bandCloud-network.cidrBlock}"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}
resource "aws_network_acl_rule" "outbound_ping-be-admin" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 120
    egress = true
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}


# Allow emphemeral
resource "aws_network_acl_rule" "inbound_emphem-be-admin" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 130
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}
resource "aws_network_acl_rule" "outbound_emphem-be-admin" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 130
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}

# Outbound HTTPs
resource "aws_network_acl_rule" "outbound_https-be-admin" {
    network_acl_id = aws_network_acl.be-admin-nacl.id
    rule_number = 140
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
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
    # subnet_ids = [ aws_subnet.frontend-SubA.id, aws_subnet.frontend-SubB.id ]
    tags = {
        Name = "fe-app-nacl"
    }
}


# Allow http-8080
resource "aws_network_acl_rule" "inbound_http-fe-app" {
    network_acl_id = aws_network_acl.fe-app-nacl.id
    rule_number = 100
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 8080
    to_port = 8080
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}
resource "aws_network_acl_rule" "outbound_http-fe-app" {
    network_acl_id = aws_network_acl.fe-app-nacl.id
    rule_number = 100
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 8080
    to_port = 8080
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}


# Allow ping
resource "aws_network_acl_rule" "inbound_ping-fe-app" {
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
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}
resource "aws_network_acl_rule" "outbound_ping-fe-app" {
    network_acl_id = aws_network_acl.fe-app-nacl.id
    rule_number = 110
    egress = true
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}


# Allow emphemeral
resource "aws_network_acl_rule" "inbound_emphem-fe-app" {
    network_acl_id = aws_network_acl.fe-app-nacl.id
    rule_number = 120
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}
resource "aws_network_acl_rule" "outbound_emphem-fe-app" {
    network_acl_id = aws_network_acl.fe-app-nacl.id
    rule_number = 120
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}


###############################
#
# Create backend admin-nacl
#
###############################


# Create nacl
resource "aws_network_acl" "be-app-nacl" {
    vpc_id = aws_vpc.bandCloud-VPC.id
    # subnet_ids = [ aws_subnet.backend-SubA.id, aws_subnet.backend-SubB.id ]
    tags = {
        Name = "be-app-nacl"
    }
}


# Allow http-8080
resource "aws_network_acl_rule" "inbound_http-be-app" {
    network_acl_id = aws_network_acl.be-app-nacl.id
    rule_number = 100
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "${var.bandCloud-network.cidrBlock}"
    from_port = 8080
    to_port = 8080
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}
resource "aws_network_acl_rule" "outbound_http-be-app" {
    network_acl_id = aws_network_acl.be-app-nacl.id
    rule_number = 100
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "${var.bandCloud-network.cidrBlock}"
    from_port = 8080
    to_port = 8080
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}


# Allow ping
resource "aws_network_acl_rule" "inbound_ping-be-app" {
    network_acl_id = aws_network_acl.be-app-nacl.id
    rule_number = 110
    egress = false
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "${var.bandCloud-network.cidrBlock}"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}
resource "aws_network_acl_rule" "outbound_ping-be-app" {
    network_acl_id = aws_network_acl.be-app-nacl.id
    rule_number = 110
    egress = true
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "${var.bandCloud-network.cidrBlock}"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}



# Allow emphemeral
resource "aws_network_acl_rule" "inbound_emphem-be-app" {
    network_acl_id = aws_network_acl.be-app-nacl.id
    rule_number = 120
    egress = false
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "${var.bandCloud-network.cidrBlock}"
    from_port = 1024
    to_port = 65535
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}
resource "aws_network_acl_rule" "outbound_emphem-be-app" {
    network_acl_id = aws_network_acl.be-app-nacl.id
    rule_number = 120
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "${var.bandCloud-network.cidrBlock}"
    from_port = 1024
    to_port = 65535
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}


# Allow https out
resource "aws_network_acl_rule" "outbound_https-be-app" {
    network_acl_id = aws_network_acl.be-app-nacl.id
    rule_number = 130
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    depends_on = [
        aws_network_acl.be-admin-nacl,
        aws_network_acl.fe-admin-nacl,
        aws_network_acl.fe-app-nacl,
        aws_network_acl.be-app-nacl
    ]
}