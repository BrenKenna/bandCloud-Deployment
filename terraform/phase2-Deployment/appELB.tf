##########################################
# 
# Frontend Application ELB
# 
##########################################

# ELB
resource "aws_lb" "fe-app-elb" {
    name = "fe-app-elb"
    load_balancer_type = "application"
    internal = false
    subnets = [ aws_subnet.frontend-SubA.id, aws_subnet.frontend-SubB.id ]
    security_groups = [ aws_security_group.http-external-dev.id, aws_security_group.ping-external.id ] 
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



##########################################
# 
# Backend Application ELB
# 
##########################################

# ELB
resource "aws_lb" "be-app-elb" {
    name = "be-app-elb"
    load_balancer_type = "application"
    internal = true
    subnets = [ aws_subnet.backend-SubA.id, aws_subnet.backend-SubB.id ]
    security_groups = [ aws_security_group.http-internal-dev.id, aws_security_group.ping-internal.id ] 
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