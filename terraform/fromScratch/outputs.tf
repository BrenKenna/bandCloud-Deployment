output "alb_dns_name" {
    value = aws_lb.tf-app-elb.dns_name
    description = "The domain of the application load balancer"
}