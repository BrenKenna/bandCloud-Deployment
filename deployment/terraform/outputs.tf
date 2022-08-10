output "fe-alb-dns-name" {
    value = aws_lb.fe-app-elb.dns_name
    description = "The domain name of the frontent application load balancer"
}

output "be-alb-dns-name" {
    value = aws_lb.be-app-elb.dns_name
    description = "The domain name of the frontent application load balancer"
}