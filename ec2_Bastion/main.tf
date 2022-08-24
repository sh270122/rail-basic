data "aws_availability_zones" "available" {}




resource "aws_instance" "jumphost" {
  ami                    = "${var.jumphost_ami}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${var.ec2_sg_id}"]
  subnet_id              = "${var.pub_subnet}"
  key_name               = "${var.key_name}" 
  associate_public_ip_address = "true"

}





