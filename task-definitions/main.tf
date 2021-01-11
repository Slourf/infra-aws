resource "aws_ecs_task_definition" "nginx" {
  family                   = "nginx"
  container_definitions    = file("./task-definitions/config/nginx.json")
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 1024
}