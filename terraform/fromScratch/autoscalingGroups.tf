##############################
# 
# Autoscaling Groups
# 
##############################

# First subnet
resource "aws_autoscaling_group" "asg-pubsub-1a" {
    name = "tf-asg-1a"
    launch_configuration = aws_launch_configuration.terraformLC-1a.id
    vpc_zone_identifier = [ aws_subnet.pubSub_A.id ]
    health_check_type = "ELB"
    min_size = 1
    max_size = 2

    tag {
        key = "Name"
        value = "tf-asg-1a"
        propagate_at_launch = true
    }
}

# Autoscaling attachment for asg-1a
resource "aws_autoscaling_attachment" "asg_attachment_elb-1a" {
  autoscaling_group_name = aws_autoscaling_group.asg-pubsub-1a.id
  lb_target_group_arn = aws_lb_target_group.tf-app-elb-tg.id
}


# Second subnet
resource "aws_autoscaling_group" "asg-pubsub-1b" {
    name = "tf-asg-1b"
    launch_configuration = aws_launch_configuration.terraformLC-1b.id
    vpc_zone_identifier = [ aws_subnet.pubSub_B.id ]
    health_check_type = "ELB"
    min_size = 1
    max_size = 2

    tag {
        key = "Name"
        value = "tf-asg-1b"
        propagate_at_launch = true
    }
}

# Autoscaling attachment for asg-1b
resource "aws_autoscaling_attachment" "asg_attachment_elb-1b" {
  autoscaling_group_name = aws_autoscaling_group.asg-pubsub-1b.id
  lb_target_group_arn = aws_lb_target_group.tf-app-elb-tg.id
}