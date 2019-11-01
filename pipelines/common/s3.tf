resource "aws_s3_bucket" "prm-codebuild-infra-artifact" {
  bucket        = "prm-${var.caller_identity_current_account_id}-codebuild-infra-artifact"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "prm-codebuild-gp-portal-artifact" {
  bucket        = "prm-${var.caller_identity_current_account_id}-codebuild-gp-portal-artifact"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "prm-codebuild-image-artifact" {
  bucket        = "prm-${var.caller_identity_current_account_id}-codebuild-image-artifact"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}

