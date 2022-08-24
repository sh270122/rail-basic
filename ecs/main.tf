
resource "aws_ecs_cluster" "web-cluster" {
  name        = "${var.cluster_name}"
}


/*resource "aws_ecr_repository" "rails-poc_ecr" {
  name                 = "rails-poc"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}*/

resource "aws_ecs_task_definition" "task-definition-test" {
  family                = "rails-task"  
  container_definitions = jsonencode([
    {
      name      = "rails"
      image     = "${var.image_name}"
      cpu       = 0
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = "${var.container_port}",
          hostPort      = 0
        }
      ]
    }
  ])
  network_mode          = "bridge"
}


resource "aws_ecs_service" "service" {
  name            = "rails-service"
  cluster         = "${aws_ecs_cluster.web-cluster.id}"
  task_definition = "${aws_ecs_task_definition.task-definition-test.arn}"
  desired_count   = "1"
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
 
 launch_type = "EC2"
load_balancer {
    target_group_arn = "${var.tg_arn}"
    container_name   = "rails"
    container_port   = 80
  }



}















