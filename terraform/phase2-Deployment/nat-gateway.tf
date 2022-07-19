#################################################
#################################################
# 
# Backend NAT Gateway
# 
#################################################
#################################################

# Create nat-az1
resource "aws_eip" "eip-be" {
    vpc = true
}
resource "aws_nat_gateway" "nat-be" {
    allocation_id = aws_eip.eip-be.id
    subnet_id = aws_subnet.frontend-SubA.id
    tags = {
        Name = "nat-be-a"
    }

}


/*
# Create nat-az1
resource "aws_eip" "eip-be-b" {
    vpc = true
}
resource "aws_nat_gateway" "nat-be-b" {
    allocation_id = aws_eip.eip-be-b.id
    subnet_id = aws_subnet.frontend-SubB.id
    tags = {
        Name = "nat-be-b"
    }
    depends_on = [ aws_eip.eip-be.b ]
}
*/