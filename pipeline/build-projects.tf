resource "aws_codebuild_project" "devops-build-toh-backend" {
  name          = "devops-build-toh-backend"
  description   = "Build toh backend image"
  service_role  = aws_iam_role.devops-codebuild-project-toh-backend-role.arn

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
      value = aws_ecr_repository.ecr-toh-backend.repository_url
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

resource "aws_codebuild_project" "devops-build-toh-frontend" {
  name          = "devops-build-toh-frontend"
  description   = "Build toh frontend images"
  service_role  = aws_iam_role.devops-codebuild-project-toh-frontend-role.arn

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
      value = aws_ecr_repository.ecr-toh-frontend.repository_url
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
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

