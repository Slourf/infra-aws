resource "aws_security_group" "sg_service_frontend" {
  name   = "${var.app_name}-sg-service-frontend"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = var.frontend_port
    to_port     = var.frontend_port
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

resource "aws_ecs_service" "service_frontend" {
  name            = "${var.app_name}-service-frontend"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.frontend.id
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
    security_groups  = [aws_security_group.sg_service_frontend.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_tg_frontend.arn
    container_name   = "${var.app_name}-frontend"
    container_port   = var.frontend_port
  }
}