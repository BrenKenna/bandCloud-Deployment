##################################################
# 
# Frontend Autoscaling Groups
# 
##################################################

# First subnet
resource "aws_autoscaling_group" "asg-fe-1a" {
    name = "fe-asg-1a"
    launch_configuration = aws_launch_configuration.frontend-LC-1a.id
    vpc_zone_identifier = [ aws_subnet.frontend-SubA.id ]
    health_check_type = "ELB"
    min_size = 1
    max_size = 2

    tag {
        key = "Name"
        value = "fe-asg-1a"
        propagate_at_launch = true
    }
}

# Autoscaling attachment for asg-1a
resource "aws_autoscaling_attachment" "fe-asg_attachment_elb-1a" {
  autoscaling_group_name = aws_autoscaling_group.asg-fe-1a.id
  lb_target_group_arn = aws_lb_target_group.fe-app-elb-tg.id
}


# Second subnet
resource "aws_autoscaling_group" "asg-fe-1b" {
    name = "fe-asg-1b"
    launch_configuration = aws_launch_configuration.frontend-LC-1b.id
    vpc_zone_identifier = [ aws_subnet.frontend-SubA.id ]
    health_check_type = "ELB"
    min_size = 1
    max_size = 2

    tag {
        key = "Name"
        value = "fe-asg-1b"
        propagate_at_launch = true
    }
}

# Autoscaling attachment for asg-1b
resource "aws_autoscaling_attachment" "fe-asg_attachment_elb-1b" {
  autoscaling_group_name = aws_autoscaling_group.asg-fe-1b.id
  lb_target_group_arn = aws_lb_target_group.fe-app-elb-tg.id
}




##################################################
# 
# Backend Autoscaling Groups
# 
##################################################

# First subnet
resource "aws_autoscaling_group" "asg-be-1a" {
    name = "be-asg-1a"
    launch_configuration = aws_launch_configuration.backend-LC-1a.id
    vpc_zone_identifier = [ aws_subnet.backend-SubA.id ]
    health_check_type = "ELB"
    min_size = 1
    max_size = 2

    tag {
        key = "Name"
        value = "be-asg-1a"
        propagate_at_launch = true
    }
}

# Autoscaling attachment for asg-1a
resource "aws_autoscaling_attachment" "be-asg_attachment_elb-1a" {
  autoscaling_group_name = aws_autoscaling_group.asg-be-1a.id
  lb_target_group_arn = aws_lb_target_group.be-app-elb-tg.id
}


# Second subnet
resource "aws_autoscaling_group" "asg-be-1b" {
    name = "be-asg-1b"
    launch_configuration = aws_launch_configuration.backend-LC-1b.id
    vpc_zone_identifier = [ aws_subnet.backend-SubA.id ]
    health_check_type = "ELB"
    min_size = 1
    max_size = 2

    tag {
        key = "Name"
        value = "be-asg-1b"
        propagate_at_launch = true
    }
}

# Autoscaling attachment for asg-1b
resource "aws_autoscaling_attachment" "be-asg_attachment_elb-1b" {
  autoscaling_group_name = aws_autoscaling_group.asg-be-1b.id
  lb_target_group_arn = aws_lb_target_group.be-app-elb-tg.id
}