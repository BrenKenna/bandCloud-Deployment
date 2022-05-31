##########################
# 
# Application ELB
# 
##########################

# ELB
resource "aws_lb" "tf-app-elb" {
    name = "tf-app-elb"
    load_balancer_type = "application"
    subnets = [ aws_subnet.pubSub_A.id, aws_subnet.pubSub_B.id ]
    security_groups = [ aws_security_group.httpAnywhere.id ] 
}

# Listener
resource "aws_lb_listener" "tf-app-elb-http" {
    load_balancer_arn = aws_lb.tf-app-elb.arn
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
resource "aws_lb_target_group" "tf-app-elb-tg" {
    name = "tf-app-elb-tg"
    port = 8080
    protocol = "HTTP"
    vpc_id = aws_vpc.terraformVPC.id

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
resource "aws_lb_listener_rule" "tf-app-elb-lr" {
    listener_arn = aws_lb_listener.tf-app-elb-http.arn
    priority = 100

    condition {
      path_pattern {
          values = ["*"]
      }
    }

    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.tf-app-elb-tg.arn
    }
}