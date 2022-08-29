data "aws_availability_zones" "available" {}

resource "aws_launch_configuration" "rails-lc" {
  name                   = "rails-lc"
  image_id               = "${var.ecs_ami}"
  instance_type          = "${var.instance_type}"
  security_groups        = ["${var.pri_ec2_sg_id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.test_profile.name}"
  key_name               = "${var.key_name}"
  user_data              = <<EOF
  #! /bin/bash
  sudo echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
  EOF

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_iam_instance_profile" "test_profile" {
  name = "rail_profile"
  role = aws_iam_role.ecs-instance-role.name
}

resource "aws_iam_role" "ecs-instance-role" {
  name = "ecs-instance-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_service_role" {
  role = aws_iam_role.ecs-instance-role.name
}


resource "aws_autoscaling_group" "rails-asg" {
  launch_configuration = "${aws_launch_configuration.rails-lc.name}"
  vpc_zone_identifier  = ["${var.private-sub1}" , "${var.private-sub2}"]
  target_group_arns    = ["${var.target_group_arn}"]
  protect_from_scale_in = true
  health_check_type    = "ELB"
  desired_capacity     = 1
  min_size = 1
  max_size = 5

  tag {
    key                 = "Name"
    value               = "rails-asg"
    propagate_at_launch = true
  }
}
