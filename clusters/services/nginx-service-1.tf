resource "aws_security_group" "nginx-service-1-sg-1" {
  name   = "nginx-service-1-sg-1"
  vpc_id = "vpc-03df9eb37ed9e541e"
  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_ecs_service" "nginx-service-1" {
  name            = "nginx-service-1"
  cluster         = module.clusters.devops-cluster-2.id
  task_definition = module.tasks.nginx.id
  launch_type     = "FARGATE"
  desired_count   = 2
  network_configuration {
    subnets          = ["subnet-0d2b2cc1b0aae98c2"]
    assign_public_ip = true
    security_groups  = [aws_security_group.nginx-service-1-sg-1.id]
  }
}