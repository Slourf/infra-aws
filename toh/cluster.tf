resource "aws_ecs_cluster" "cluster" {
  name               = "${var.app_name}-cluster"
  capacity_providers = ["FARGATE"]
}