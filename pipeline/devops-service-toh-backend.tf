resource "aws_security_group" "devops-service-sg-toh-backend" {
  name   = "devops-service-sg-toh-backend"
  vpc_id = "vpc-03df9eb37ed9e541e"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
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

resource "aws_ecs_service" "devops-service-toh-backend" {
  name            = "devops-service-toh-backend"
  cluster         = aws_ecs_cluster.devops-cluster-toh.id
  task_definition = aws_ecs_task_definition.toh-backend.id
  launch_type     = "FARGATE"
  desired_count   = 2
  network_configuration {
    subnets          = ["subnet-0d2b2cc1b0aae98c2"]
    assign_public_ip = true
    security_groups  = [aws_security_group.devops-service-sg-toh-backend.id]
  }
}