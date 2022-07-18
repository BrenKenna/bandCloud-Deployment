######################################
# 
# Configure Frontend:
#   i). IGW
#   ii). Routing
# 
######################################

# Internet gateway
resource "aws_internet_gateway" "bandCloud-igw" {
    vpc_id = aws_vpc.bandCloud-VPC.id
    tags = {
        Name = "bandCloud-igw"
    }
    depends_on = [ aws_vpc.bandCloud-VPC ]
}

# Route table for adding public subnets routes to
resource "aws_route_table" "fe-rtb-pub" {
    vpc_id = aws_vpc.bandCloud-VPC.id
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
    gateway_id = aws_internet_gateway.bandCloud-igw.id
}


# Add a route to public subnet-A
resource "aws_route_table_association" "fe-rta-pubSub-a" {
    subnet_id = aws_subnet.frontend-SubA.id
    route_table_id = aws_route_table.fe-rtb-pub.id
}


# Add a route to the public subnet-B
resource "aws_route_table_association" "fe-rta-pubSub-b" {
    subnet_id = aws_subnet.frontend-SubB.id
    route_table_id = aws_route_table.fe-rtb-pub.id
}



######################################
# 
# Configure Backend:
#   i). Nat
#   ii). Associate subnets
# 
######################################

# Create route table
resource "aws_route_table" "be-rtb-priv" {
    vpc_id = aws_vpc.bandCloud-VPC.id
    tags = {
        Name = "backend-private-rtb"
    }
    depends_on = [ aws_nat_gateway.nat-be, aws_vpc.bandCloud-VPC ]
}


######################################
# 
# Add (in)outbound routes
# 
######################################

# Configure route to nat
resource "aws_route" "be-route-nat" {
    route_table_id = aws_route_table.be-rtb-priv.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-be
}

# Add a route to private subnet-A
resource "aws_route_table_association" "be-rta-pubSub-a" {
    subnet_id = aws_subnet.backend-SubA.id
    route_table_id = aws_route_table.be-rtb-priv.id
}

# Add a route to the private subnet-B
resource "aws_route_table_association" "be-rta-pubSub-b" {
    subnet_id = aws_subnet.backend-SubB.id
    route_table_id = aws_route_table.be-rtb-priv.id
}