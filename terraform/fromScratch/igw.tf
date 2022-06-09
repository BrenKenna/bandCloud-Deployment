######################################
# 
# Configure Frontend:
#   i). IGW
#   ii). Routing
# 
######################################

# Internet gateway
resource "aws_internet_gateway" "frontend_igw" {
    vpc_id = aws_vpc.bandCloud-VPC.id
    tags = {
        Name = "frontend_IGW"
    }
}

# Route table for adding public subnets routes to
resource "aws_route_table" "fe-rtb-pub" {
    vpc_id = aws_vpc.bandCloud-VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.frontend_igw.id
    }
    tags = {
        Name = "frontend-public-rtb"
    }
}


######################################
# 
# Add (in)outbound routes
# 
######################################

# Route out to any IP via gateway
resource "aws_route" "fe-route-igw" {
    route_table_id = aws_route_table.fe-rtb-pub.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.frontend_igw.id
}


# Add a route to public subnet-A
resource "aws_route_table_association" "fe-rta-pubSub-a" {
    subnet_id = aws_subnet.frontend-SubA.id
    route_table_id = aws_route_table.fe-rtb_pub.id
}


# Add a route to the public subnet-B
resource "aws_route_table_association" "fe-rta-pubSub-b" {
    subnet_id = aws_subnet.frontend-SubB.id
    route_table_id = aws_route_table.fe-rtb_pub.id
}



######################################
# 
# Configure Backend:
#   i). IGW
#   ii). Routing
# 
######################################

# Internet gateway
resource "aws_internet_gateway" "backend_igw" {
    vpc_id = aws_vpc.bandCloud-VPC.id
    tags = {
        Name = "backend_IGW"
    }
}

# Route table for adding public subnets routes to
resource "aws_route_table" "be-rtb-pub" {
    vpc_id = aws_vpc.bandCloud-VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.backend_igw.id
    }
    tags = {
        Name = "backend-public-rtb"
    }
}


######################################
# 
# Add (in)outbound routes
# 
######################################

# Route out to any IP via gateway
resource "aws_route" "be-route-igw" {
    route_table_id = aws_route_table.be-rtb-pub.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.backend_igw.id
}


# Add a route to public subnet-A
resource "aws_route_table_association" "be-rta-pubSub-a" {
    subnet_id = aws_subnet.backend-SubA.id
    route_table_id = aws_route_table.be-rtb_pub.id
}


# Add a route to the public subnet-B
resource "aws_route_table_association" "be-rta-pubSub-b" {
    subnet_id = aws_subnet.backend-SubB.id
    route_table_id = aws_route_table.be-rtb_pub.id
}