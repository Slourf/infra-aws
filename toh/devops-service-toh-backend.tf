resource "aws_security_group" "sg_service_backend" {
  name   = "${var.app_name}-sg-service-backend"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = var.backend_port
    to_port     = var.backend_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "service_backend" {
  name            = "${var.app_name}-service-backend"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.backend.id
  launch_type     = "FARGATE"
  desired_count   = 2
  deployment_maximum_percent = 100
  deployment_minimum_healthy_percent = 0

  network_configuration {
    subnets          = [
      aws_subnet.vpc_subnet_1.id,
      aws_subnet.vpc_subnet_2.id
    ]
    assign_public_ip = true
    security_groups  = [aws_security_group.sg_service_backend.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_tg_backend.arn
    container_name   = "${var.app_name}-backend"
    container_port   = var.backend_port
  }
}