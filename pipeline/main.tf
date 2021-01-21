
resource "aws_s3_bucket" "pipeline_bucket" {
    bucket        = "devops-pipeline-bucket-1" 
    acl           = "private"
    force_destroy = true
}

resource "aws_codepipeline" "pipeline" {
  name     = "devops-pipeline-1"
  role_arn = aws_iam_role.devops-pipeline-iam-role-1.arn

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
        ConnectionArn        = "arn:aws:codestar-connections:eu-west-3:120523844784:connection/df4c72ac-2c1e-48f4-b15b-9bcd07b3eadf"
        FullRepositoryId     = "Slourf/Tour-of-Heroes"
        BranchName           = "main"
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
        ProjectName = aws_codebuild_project.devops-build-toh-backend.name
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
        ProjectName = aws_codebuild_project.devops-build-toh-frontend.name
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
          ClusterName = "devops-cluster-toh"
          ServiceName = "devops-service-toh-backend"
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
          ClusterName = "devops-cluster-toh"
          ServiceName = "devops-service-toh-frontend"
      }
    }
  }
}