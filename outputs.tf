output "load_balancer_dns" {
  value = aws_lb.devops_alb.dns_name
}
