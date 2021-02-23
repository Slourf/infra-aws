
resource "aws_s3_bucket" "pipeline_bucket" {
    bucket        = "devops-pipeline-bucket-1" 
    acl           = "private"
    force_destroy = true
}

resource "aws_codepipeline" "devops_pipeline_toh" {
  name     = "devops-pipeline-toh"
  role_arn = aws_iam_role.devops_pipeline_iam_role_1.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_bucket.bucket
    type     = "S3"
    /*
    encryption_key {
      id   = data.aws_kms_alias.s3kmskey.arn
      type = "KMS"
    }
    */
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn        = var.github.connection_arn
        FullRepositoryId     = var.github.repository
        BranchName           = var.github.branch
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "BuildBackend"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["backend_build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.devops_build_toh_backend.name
      }
    }

    action {
      name             = "BuildFrontend"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["frontend_build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.devops_build_toh_frontend.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployBackend"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["backend_build_output"]
      version         = "1"

      configuration = {
          ClusterName = aws_ecs_cluster.devops_cluster_toh.name
          ServiceName = aws_ecs_service.devops_service_toh_backend.name
      }
    }

    action {
      name            = "DeployFrontend"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["frontend_build_output"]
      version         = "1"

      configuration = {
          ClusterName = aws_ecs_cluster.devops_cluster_toh.name
          ServiceName = aws_ecs_service.devops_service_toh_frontend.name
      }
    }
  }
}