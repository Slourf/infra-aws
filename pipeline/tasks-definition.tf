resource "aws_ecs_task_definition" "toh-frontend" {
  family                   = "toh-frontend"
  container_definitions    = templatefile(
    "./pipeline/toh-frontend.json",
    { repository_url =  aws_ecr_repository.ecr-toh-frontend.repository_url }
  )
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 1024
  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_task_definition" "toh-backend" {
  family                   = "toh-backend"
  container_definitions    = templatefile(
    "./pipeline/toh-backend.json",
    { repository_url =  aws_ecr_repository.ecr-toh-backend.repository_url }
  )
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 1024
  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
}