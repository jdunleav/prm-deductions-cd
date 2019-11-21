resource "aws_codebuild_project" "prm-deductions-infra-apply" {
  name          = "prm-deductions-infra-apply"
  description   = "Applies the infrastructure"
  build_timeout = "5"
  service_role = var.service_role

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "${var.caller_identity_current_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/codebuild/terraform012-new:latest"
    type         = "LINUX_CONTAINER"
          
    environment_variable {
      name  = "ASSUME_ROLE_NAME"
      value = var.role_arn
    }

    environment_variable {
      name = "ENVIRONMENT"
      value = var.environment
    }

    environment_variable {
      name = "ACCOUNT_ID"
      value = var.caller_identity_current_account_id
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./buildspec.yml"
  }
}