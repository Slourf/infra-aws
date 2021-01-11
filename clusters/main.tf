resource "aws_ecs_cluster" "devops-cluster-2" {
  name               = "devops-cluster-2"
  capacity_providers = ["FARGATE"]
}