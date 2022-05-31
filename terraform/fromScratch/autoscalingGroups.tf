##############################
# 
# Autoscaling Groups
# 
##############################

# First subnet
resource "aws_autoscaling_group" "asg-pubsub-1a" {
    launch_configuration = aws_launch_configuration.terraformLC-1a.id
    vpc_zone_identifier = [ aws_subnet.pubSub_A.id ]

    target_group_arns = [ aws_lb.tf-app-elb.arn ]
    health_check_type = "ELB"

    min_size = 1
    max_size = 2

    tag {
        key = "Name"
        value = "terraform-asg-1a"
        propagate_at_launch = true
    }
}


# Second subnet
resource "aws_autoscaling_group" "asg-pubsub-1b" {
    launch_configuration = aws_launch_configuration.terraformLC-1b.id
    vpc_zone_identifier = [ aws_subnet.pubSub_B.id ]

    target_group_arns = [ aws_lb.tf-app-elb.arn ]
    health_check_type = "ELB"

    min_size = 1
    max_size = 2

    tag {
        key = "Name"
        value = "terraform-asg-1b"
        propagate_at_launch = true
    }
}