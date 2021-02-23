resource "aws_security_group" "devops_service_sg_toh_frontend" {
  name   = "devops-service-sg-toh-frontend"
  vpc_id = aws_vpc.devops_vpc_toh.id

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

resource "aws_ecs_service" "devops_service_toh_frontend" {
  name            = "devops-service-toh-frontend"
  cluster         = aws_ecs_cluster.devops_cluster_toh.id
  task_definition = aws_ecs_task_definition.toh_frontend.id
  launch_type     = "FARGATE"
  desired_count   = 2
  deployment_maximum_percent = 100
  deployment_minimum_healthy_percent = 0

  network_configuration {
    subnets          = [
      aws_subnet.devops_vpc_toh_subnet_1.id,
      aws_subnet.devops_vpc_toh_subnet_2.id
    ]
    assign_public_ip = true
    security_groups  = [aws_security_group.devops_service_sg_toh_frontend.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.devops_lb_tg_toh_frontend.arn
    container_name   = "toh-frontend"
    container_port   = var.frontend_port
  }
}