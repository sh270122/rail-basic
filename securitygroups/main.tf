#Load Balancer Security Group

resource "aws_security_group" "rails-poc-alb-sg" {
  name   = "rails-poc-alb-sg"
  vpc_id = "${var.vpc_id}"
  ingress {
    description      = "allow http traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
 }
  ingress {
    description      = "allow https traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
 }
 egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  
tags = {
  Name = "rails-alb-sg"
 }
}

#############################
# jump host

resource "aws_security_group" "rails-ec2-sg" {
  name               = "rails-poc-ec2-sg"
  vpc_id             = "${var.vpc_id}"
 ingress {
    description      = "allow ssh traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["175.101.3.226/32" , "182.71.17.50/32" , "103.248.208.34/32"]
 }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
 tags = {
   Name = "rails-asg-sg"
 }
}


#################################
# RDS security group

resource "aws_security_group" "rails-rds-sg" {
  vpc_id = "${var.vpc_id}"
  name   = "rails-poc-rds-sg"
 ingress {
    description      = "allow ssh traffic"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = ["${var.ec2_sg}"]

 }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
tags = {
  Name = "rails-rds-sg"
}
}

################################
# private ec2 sg  (auto scaling pri instances)


resource "aws_security_group" "rails-pri-ec2-sg" {
  vpc_id = "${var.vpc_id}"
  name   = "rails-pri-ec2-sg"
 ingress {
    description      = "allow ssh traffic from jumphost"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = ["${var.ec2_sg}"]
 }


 ingress {
    description      = "allow http traffic"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    #cidr_blocks      = ["0.0.0.0/0"]
    security_groups  = ["${var.alb_sg}"] 
 }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
tags = {
  Name = "rails-pri-ec2-sg"
}
}



