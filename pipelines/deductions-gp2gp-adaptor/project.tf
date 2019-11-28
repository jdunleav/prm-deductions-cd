
resource "aws_codebuild_project" "prm-build-gp2gp-adaptor-image" {
  name          = "prm-build-gp2gp-adaptor-image"
  description   = "Builds gp2gp-adaptor image"
  build_timeout = "5"

  service_role = var.service_role

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/docker:17.09.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.caller_identity_current_account_id
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = var.ecr_repo_name
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name  = "IMAGE_DIR"
      value = "terraform"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./buildspec.yml"
  }
}

resource "aws_codebuild_project" "prm-deploy-gp2gp-adaptor" {
  name          = "prm-deploy-gp2gp-adaptor"
  description   = "Creates/Updates Fargate Task and Service and deploys GP2GP Adaptor image"
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
    buildspec = "./buildspec-tf.yml"
  }
}

resource "aws_codebuild_project" "prm-unit-test-gp2gp-adaptor" {
  name        = "prm-unit-test-gp2gp-adaptor"
  description = "Unit Tests GP2GP Adaptor"

  service_role = var.service_role

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "${var.caller_identity_current_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/codebuild/node:latest"
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
    buildspec = "./buildspec-test.yml"
  }
}

resource "aws_codebuild_project" "prm-dependency-check-gp2gp-adaptor" {
  name        = "prm-dependency-check-gp2gp-adaptor"
  description = "GP2GP Adaptor Dependency Check"

  service_role = var.service_role

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "${var.caller_identity_current_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/codebuild/node:latest"
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
    buildspec = "./buildspec-dep.yml"
  }
}