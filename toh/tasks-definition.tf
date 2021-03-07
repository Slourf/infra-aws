resource "aws_ecs_task_definition" "frontend" {
  family                   = "${var.app_name}-frontend"
  container_definitions    = templatefile(
    "./toh/${var.app_name}-frontend.json",
    { repository_url =  aws_ecr_repository.ecr_frontend.repository_url }
  )
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 1024
  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "backend"
  container_definitions    = templatefile(
    "./toh/${var.app_name}-backend.json",
    { repository_url =  aws_ecr_repository.ecr_backend.repository_url }
  )
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 1024
  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
}