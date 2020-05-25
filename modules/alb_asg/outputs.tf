output "alb_dns_name" {
  value = aws_lb.my-alb.dns_name
}

output "webserver_sg_id" {
  value = [aws_security_group.sg-instances.id]
}

output "asg_name" {
  value = aws_autoscaling_group.my-autoscaling.name
}