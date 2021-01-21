resource "aws_ecs_cluster" "devops-cluster-toh" {
  name               = "devops-cluster-toh"
  capacity_providers = ["FARGATE"]
}