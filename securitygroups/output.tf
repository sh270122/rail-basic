output "alb_sg" {
   value = "${aws_security_group.rails-poc-alb-sg.id}"
}

output "ec2_sg" {
   value = "${aws_security_group.rails-ec2-sg.id}"
}

output "rds_sg" {
   value = "${aws_security_group.rails-rds-sg.id}"
}

output "pri_ec2_sg" {
  value = "${aws_security_group.rails-pri-ec2-sg.id}"
}