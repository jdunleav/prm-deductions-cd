resource "aws_ecr_repository" "gp-portal-ecr-repo" {
    name = "deductions/gp-portal"
}

resource "aws_ecr_repository" "pds-adaptor-ecr-repo" {
    name = "deductions/pds-adaptor"
}

resource "aws_ecr_repository" "terraform-012-image" {
    name = "codebuild/terraform012-new"
}

resource "aws_ecr_repository" "node-image" {
    name = "codebuild/node"
}

data "aws_iam_policy_document" "code_build_access" {
  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${var.caller_identity_current_account_id}:root"]
    }

    principals {
      type = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages"
    ]
  }
}

resource "aws_ecr_repository_policy" "terraform-012-image" {
    repository = "${aws_ecr_repository.terraform-012-image.name}"

    policy = "${data.aws_iam_policy_document.code_build_access.json}"
}

resource "aws_ecr_repository_policy" "node-image-policy" {
    repository = "${aws_ecr_repository.node-image.name}"

    policy = "${data.aws_iam_policy_document.code_build_access.json}"
}
