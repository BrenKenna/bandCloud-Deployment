######################################
# 
# Configure IGW and Route Table
# 
######################################

# Internet gateway
resource "aws_internet_gateway" "terraform_igw" {
    vpc_id = aws_vpc.terraformVPC.id
    tags = {
        Name = "terraformIGW"
    }
}

# Route table for adding public subnets routes to
resource "aws_route_table" "rtb_pub" {
    vpc_id = aws_vpc.terraformVPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.terraform_igw.id
    }
    tags = {
        Name = "terraform-public-rtb"
    }
}


######################################
# 
# Add (in)outbound routes
# 
######################################

# Route out to any IP via gateway
resource "aws_route" "route-igw" {
    route_table_id = aws_route_table.rtb_pub.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
}


# Add a route to public subnet-A
resource "aws_route_table_association" "rta-pubSub-a" {
    subnet_id = aws_subnet.pubSub_A.id
    route_table_id = aws_route_table.rtb_pub.id
}


# Add a route to the public subnet-B
resource "aws_route_table_association" "rta-pubSub-b" {
    subnet_id = aws_subnet.pubSub_B.id
    route_table_id = aws_route_table.rtb_pub.id
}