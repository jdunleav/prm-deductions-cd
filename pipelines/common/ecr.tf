resource "aws_ecr_repository" "gp-portal-ecr-repo" {
    name = "deductions/gp-portal"
}

resource "aws_ecr_repository" "terraform-012-image" {
    name = "codebuild/terraform012-new"
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
