resource "aws_ecr_repository" "ecr-toh-frontend" {
    name = "toh-frontend"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
      scan_on_push = true
    }
}

resource "aws_ecr_repository" "ecr-toh-backend" {
    name = "toh-backend"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
      scan_on_push = true
    }
}