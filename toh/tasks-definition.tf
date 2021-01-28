resource "aws_ecs_task_definition" "toh_frontend" {
  family                   = "toh-frontend"
  container_definitions    = templatefile(
    "./toh/toh-frontend.json",
    { repository_url =  aws_ecr_repository.ecr_toh_frontend.repository_url }
  )
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 1024
  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_task_definition" "toh_backend" {
  family                   = "toh-backend"
  container_definitions    = templatefile(
    "./toh/toh-backend.json",
    { repository_url =  aws_ecr_repository.ecr_toh_backend.repository_url }
  )
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 1024
  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
}