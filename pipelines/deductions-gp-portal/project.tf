
resource "aws_codebuild_project" "prm-build-gp-portal-image" {
  name          = "prm-build-gp-portal-image"
  description   = "Builds gp portal image"
  build_timeout = "5"

  service_role = "${var.service_role}"

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
      value = "${var.aws_region}"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "${var.caller_identity_current_account_id}"
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = "${var.ecr_repo_name}"
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