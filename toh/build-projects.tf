resource "aws_codebuild_project" "build_backend" {
  name          = "${var.app_name}-build-backend"
  description   = "Build toh backend image"
  service_role  = aws_iam_role.codebuild_project_backend_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.ecr_backend.repository_url
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }
    environment_variable {
      name  = "DB_USER"
      value = var.db_user
    }
    environment_variable {
      name  = "DB_PASSWORD"
      value = var.db_password
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec = "${var.app_name}-backend-buildspec.yml"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "Devops"
      stream_name = "${var.app_name}-codebuild-backend"
    }
  }
}

resource "aws_codebuild_project" "build_frontend" {
  name          = "${var.app_name}-build-frontend"
  description   = "Build toh frontend images"
  service_role  = aws_iam_role.codebuild_project_frontend_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.ecr_frontend.repository_url
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name = "SERVER_URL"
      value = aws_lb.lb_backend.dns_name
    }

    environment_variable {
      name = "SERVER_PORT"
      value = var.backend_port
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec = "${var.app_name}-frontend-buildspec.yml"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "Devops"
      stream_name = "${var.app_name}-codebuild-frontend"
    }
  }
}

