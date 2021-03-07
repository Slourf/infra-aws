resource "aws_ecr_repository" "ecr_frontend" {
    name = "${var.app_name}-frontend"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
      scan_on_push = true
    }
}

resource "aws_ecr_repository" "ecr_backend" {
    name = "${var.app_name}-backend"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
      scan_on_push = true
    }
}