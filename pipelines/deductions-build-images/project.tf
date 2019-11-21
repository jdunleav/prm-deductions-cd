resource "aws_codebuild_project" "prm-build-terraform-012-image" {
  name          = "prm-deductions-build-terraform-012-image"
  description   = "Builds terraform 0.12 image"
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
      value = var.terraform_ecr_repo_name
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name  = "IMAGE_DIR"
      value = "terraform012"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./pipelines/deductions-build-images/buildspec.yml"
  }
}

resource "aws_codebuild_project" "prm-build-node-image" {
  name          = "prm-deductions-build-node-image"
  description   = "Builds node image"
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
      value = var.node_ecr_repo_name
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name  = "IMAGE_DIR"
      value = "node"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./pipelines/deductions-build-images/buildspec.yml"
  }
}
