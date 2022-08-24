output "public_subnets" {
  value = "${aws_subnet.public_subnet.*.id}"
}

output "private_subnets" {
  value = "${aws_subnet.private_subnet.*.id}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "subnet1" {
  value = "${element(aws_subnet.public_subnet.*.id, 1 )}"
}

output "subnet2" {
  value = "${element(aws_subnet.public_subnet.*.id, 2 )}"
}

output "private_subnet1" {
  value = "${element(aws_subnet.private_subnet.*.id, 1 )}"
}

output "private_subnet2" {
  value = "${element(aws_subnet.private_subnet.*.id, 2 )}"
}
  /*
output "alb_sg" {
   value = "${aws_security_group.rails-poc-alb-sg.id}"
}

output "ecc_sg" {
   value = "${aws_security_group.test_sg.id}"
}

output "rds_sg" {
   value = "${aws_security_group.rails-rds-sg.id}"
}
*/