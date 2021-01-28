resource "aws_codebuild_project" "devops_build_toh_backend" {
  name          = "devops-build-toh-backend"
  description   = "Build toh backend image"
  service_role  = aws_iam_role.devops_codebuild_project_toh_backend_role.arn

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
      value = aws_ecr_repository.ecr_toh_backend.repository_url
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec = "toh-backend-buildspec.yml"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "Devops"
      stream_name = "codebuild-toh-backend"
    }
  }
}

resource "aws_codebuild_project" "devops_build_toh_frontend" {
  name          = "devops-build-toh-frontend"
  description   = "Build toh frontend images"
  service_role  = aws_iam_role.devops_codebuild_project_toh_frontend_role.arn

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
      value = aws_ecr_repository.ecr_toh_frontend.repository_url
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name = "SERVER_URL"
      value = aws_lb.devops_lb_toh_backend.dns_name
    }

    environment_variable {
      name = "SERVER_PORT"
      value = "3000"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec = "toh-frontend-buildspec.yml"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "Devops"
      stream_name = "codebuild-toh-frontend"
    }
  }
}

