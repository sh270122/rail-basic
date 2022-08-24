resource "aws_lb_target_group" "rails-poc-target-group" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "rails-poc-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_lb" "rails-poc-aws-alb" {
  name                = "rails-poc-alb"
  internal            = false
  security_groups     = ["${var.alb_sg}"]
  subnets             = ["${var.subnet1}" , "${var.subnet2}",]
  ip_address_type     = "ipv4"
  load_balancer_type  = "application"
  tags = {
    Name = "rails-poc-alb"
  }
}

resource "aws_lb_listener" "rails-poc-alb-listner" {
  load_balancer_arn = "${aws_lb.rails-poc-aws-alb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.rails-poc-target-group.arn}"
  }
}

