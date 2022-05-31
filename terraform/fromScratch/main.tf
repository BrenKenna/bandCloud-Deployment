##################################
# 
# Spinup Instance in new VPC
# 
##################################

# Spin up example instance from image
resource "aws_instance" "terraFormTesting" {

    ami = aws_ami.terraform-example-1a.id
    instance_type = var.ec2_vars["instanceType"]
    subnet_id = aws_subnet.pubSub_A.id
    key_name = var.ec2_vars["key"]
    security_groups = [ aws_security_group.sg22.id, aws_security_group.httpAnywhere.id ]
    iam_instance_profile  = var.ec2_vars["iamRole"]
    associate_public_ip_address = true
    tags = {
        Name = "terraformApp-PubSub-A"
    }
}