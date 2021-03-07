resource "aws_iam_role" "pipeline_iam_role_1" {
    name = "${var.app_name}-pipeline-iam-role-1"
    assume_role_policy = data.aws_iam_policy_document.pipeline_assume_role.json
}

resource "aws_iam_role" "codebuild_project_backend_role" {
  name = "${var.app_name}-codebuild-project-bakcend-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}

resource "aws_iam_role" "codebuild_project_frontend_role" {
  name = "${var.app_name}-codebuild-project-frontend-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}

resource "aws_iam_policy" "pipeline_policy_1" {
  name = "${var.app_name}-pipeline-policy-1"
  policy = data.aws_iam_policy_document.policies.json
}

resource "aws_iam_policy" "codebuild_project_backend_policy" {
  name = "${var.app_name}-codebuild-project-backend-policy"
  policy = data.aws_iam_policy_document.policies_backend.json
}

resource "aws_iam_policy" "codebuild_project_frontend_policy" {
  name = "${var.app_name}-codebuild-project-frontend-policy"
  policy = data.aws_iam_policy_document.policies_frontend.json
}

resource "aws_iam_policy_attachment" "iam_attachement_1" {
  name = "${var.app_name}-iam-attachement-1"
  roles = [aws_iam_role.pipeline_iam_role_1.name]
  policy_arn = aws_iam_policy.pipeline_policy_1.arn
}

resource "aws_iam_policy_attachment" "iam_attachement_project_backend" {
  name = "${var.app_name}-iam-attachement-project-backend"
  roles = [aws_iam_role.codebuild_project_backend_role.name]
  policy_arn = aws_iam_policy.codebuild_project_backend_policy.arn
}

resource "aws_iam_policy_attachment" "iam_attachement_project_frontend" {
  name = "${var.app_name}-iam-attachement-project-frontend"
  roles = [aws_iam_role.codebuild_project_frontend_role.name]
  policy_arn = aws_iam_policy.codebuild_project_frontend_policy.arn
}

data "aws_iam_policy_document" "pipeline_assume_role" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "policies" {
  statement {
    sid = ""

    actions = [
      "iam:PassRole",
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision",
      "codestar-connections:UseConnection",
      "elasticbeanstalk:*",
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "sns:*",
      "cloudformation:*",
      "rds:*",
      "sqs:*",
      "ecs:*",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:BatchGetBuildBatches",
      "codebuild:StartBuildBatch"
    ]
    resources = [ "*" ]
    effect = "Allow"
  }

  statement {
    sid = ""

    actions = [
      "s3:*"
    ]
    resources = [ 
        aws_s3_bucket.pipeline_bucket.arn, 
        "${aws_s3_bucket.pipeline_bucket.arn}/*"
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "policies_backend" {
  statement {
    sid = ""

    actions = [
      "codebuild:BatchPutCodeCoverages",
      "codebuild:BatchPutTestCases",
      "codebuild:CreateReport",
      "codebuild:CreateReportGroup",
      "codebuild:Updatereport",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [ "*" ]
    effect = "Allow"
  }

  statement {
    sid = ""

    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.pipeline_bucket.arn,
      "${aws_s3_bucket.pipeline_bucket.arn}/*"
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "policies_frontend" {
  statement {
    sid = ""

    actions = [
      "codebuild:BatchPutCodeCoverages",
      "codebuild:BatchPutTestCases",
      "codebuild:CreateReport",
      "codebuild:CreateReportGroup",
      "codebuild:Updatereport",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [ "*" ]
    effect = "Allow"
  }

  statement {
    sid = ""

    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.pipeline_bucket.arn,
      "${aws_s3_bucket.pipeline_bucket.arn}/*"
    ]
    effect = "Allow"
  }
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}