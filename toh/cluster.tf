resource "aws_ecs_cluster" "devops_cluster_toh" {
  name               = "devops-cluster-toh"
  capacity_providers = ["FARGATE"]
}