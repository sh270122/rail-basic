output "alb_dns_name" {
  value = "${aws_lb.rails-poc-aws-alb.dns_name}"
}

output "alb_target_group_arn" {
  value = "${aws_lb_target_group.rails-poc-target-group.arn}"
}

#output "alb_sg" {
#   value = "${aws_security_group.rails-poc-alb-sg.id}"
#}



output "alb_listener" {
  value = "${aws_lb_listener.rails-poc-alb-listner}"
}

