####################################################################################
####################################################################################
# 
# Frontend Application ELB
#
# Consider adding the HTTPS listener for frontend elb target group
#  https://aws.amazon.com/premiumsupport/knowledge-center/associate-acm-certificate-alb-nlb/
# 
# 
####################################################################################
####################################################################################

# ELB
resource "aws_lb" "fe-app-elb" {
    name = "fe-app-elb"
    load_balancer_type = "application"
    internal = false
    subnets = [ aws_subnet.frontend-SubA.id, aws_subnet.frontend-SubB.id ]
    security_groups = [ aws_security_group.fe-external-dev.id ] 
}

# Listener
resource "aws_lb_listener" "fe-app-elb-http" {
    load_balancer_arn = aws_lb.fe-app-elb.arn
    port = 8080
    protocol = "HTTP"

    # Return 404
    default_action {
      type = "fixed-response"
      fixed_response {
        content_type = "text/plain"
        message_body = "404: Page Not Found :("
        status_code = 404
      }
    }
}


# Target group
resource "aws_lb_target_group" "fe-app-elb-tg" {
    name = "fe-app-elb-tg"
    port = 8080
    protocol = "HTTP"
    vpc_id = aws_vpc.bandCloud-VPC.id

    health_check {
      path = "/"
      protocol = "HTTP"
      matcher = "200"
      interval = 15
      timeout = 3
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}


# Listener Rule
resource "aws_lb_listener_rule" "fe-app-elb-lr" {
    listener_arn = aws_lb_listener.fe-app-elb-http.arn
    priority = 100

    condition {
      path_pattern {
          values = ["*"]
      }
    }

    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.fe-app-elb-tg.arn
    }
}



#######################################################################
#######################################################################
# 
# Backend Application ELB
#
# -> Canonical name DNS record of resource.bandcloud.com
#    points to the internal load balancer under the private
#    bandcloud.com domain
# 
# -> The R-53 hosted zone is edited manually => Update associated VPC 
# 
########################################################################
########################################################################

# ELB
resource "aws_lb" "be-app-elb" {
    name = "be-app-elb"
    load_balancer_type = "application"
    internal = true
    subnets = [ aws_subnet.backend-SubA.id, aws_subnet.backend-SubB.id ]
    security_groups = [ aws_security_group.be-internal-dev.id ] 
}

# Listener
resource "aws_lb_listener" "be-app-elb-http" {
    load_balancer_arn = aws_lb.be-app-elb.arn
    port = 8080
    protocol = "HTTP"

    # Return 404
    default_action {
      type = "fixed-response"
      fixed_response {
        content_type = "text/plain"
        message_body = "404: Page Not Found :("
        status_code = 404
      }
    }
}


# Target group
resource "aws_lb_target_group" "be-app-elb-tg" {
    name = "be-app-elb-tg"
    port = 8080
    protocol = "HTTP"
    vpc_id = aws_vpc.bandCloud-VPC.id

    health_check {
      path = "/projects/listProjects"
      protocol = "HTTP"
      matcher = "200"
      interval = 15
      timeout = 3
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}


# Listener Rule
resource "aws_lb_listener_rule" "be-app-elb-lr" {
    listener_arn = aws_lb_listener.be-app-elb-http.arn
    priority = 100

    condition {
      path_pattern {
          values = ["*"]
      }
    }

    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.be-app-elb-tg.arn
    }
}