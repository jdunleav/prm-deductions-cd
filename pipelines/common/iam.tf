resource "aws_iam_role" "codebuild-role" {
  name                = "${var.codebuild_role}"
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${var.caller_identity_current_account_id}:root"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "codebuild-role" {
  role = "${aws_iam_role.codebuild-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Role for generic Project
data "template_file" "codebuild-project-generic-role" {
  template = "${file("${path.module}/templates/codebuild-project-generic-role.json")}"

  vars = {
    AWS_ACCOUNT_ID = "${var.caller_identity_current_account_id}"
  }
}

resource "aws_iam_role" "deductions-codebuild-project-generic-role" {
  name               = "${var.codebuild_project_generic_role}"
  assume_role_policy = "${data.template_file.codebuild-project-generic-role.rendered}"
}

# Assume-role policy for generic project role
data "template_file" "codebuild-project-generic-assume-role-policy" {
  template = "${file("${path.module}/templates/codebuild-project-generic-assume-role-policy.json")}"

  vars = {
    ROLE = "${aws_iam_role.codebuild-role.arn}"
  }
}

resource "aws_iam_policy" "deductions-codebuild-project-generic-assume-role-policy" {
  name   = "deductions-codebuild-project-generic-assume-role-policy"
  policy = "${data.template_file.codebuild-project-generic-assume-role-policy.rendered}"
}

resource "aws_iam_role_policy_attachment" "codebuild-project-generic-assume-role-attachment" {
  role       = "${aws_iam_role.deductions-codebuild-project-generic-role.name}"
  policy_arn = "${aws_iam_policy.deductions-codebuild-project-generic-assume-role-policy.arn}"
}

# Service policy for generic project role
resource "aws_iam_policy" "deductions-codebuild-project-generic-service-policy" {
  name   = "deductions-codebuild-project-generic-service-policy"
  policy = "${data.template_file.codebuild-project-generic-service-policy.rendered}"
}

data "template_file" "codebuild-project-generic-service-policy" {
  template = "${file("${path.module}/templates/codebuild-project-generic-service-policy.json")}"

  vars = {
    AWS_REGION     = "${var.aws_region}"
    AWS_ACCOUNT_ID = "${var.caller_identity_current_account_id}"
  }
}

resource "aws_iam_role_policy_attachment" "codebuild-project-generic-service-attachment" {
  role       = "${aws_iam_role.deductions-codebuild-project-generic-role.name}"
  policy_arn = "${aws_iam_policy.deductions-codebuild-project-generic-service-policy.arn}"
}

# Role for generic Pipeline
resource "aws_iam_role" "deductions-codepipeline-generic-role" {
  name               = "${var.codepipeline_generic_role}"
  assume_role_policy = "${file("${path.module}/templates/codepipeline-generic-role.json")}"
}

resource "aws_iam_role_policy_attachment" "codepipeline-generic-role-attachment" {
  role       = "${aws_iam_role.deductions-codepipeline-generic-role.name}"
  policy_arn = "${aws_iam_policy.deductions-codepipeline-generic-policy.arn}"
}

resource "aws_iam_policy" "deductions-codepipeline-generic-policy" {
  name   = "deductions-codepipeline-generic-policy"
  policy = "${data.template_file.codepipeline-generic-policy.rendered}"
}

data "template_file" "codepipeline-generic-policy" {
  template = "${file("${path.module}/templates/codepipeline-generic-policy.json")}"

  vars = {
    PRM_CODEBUILD_INFRA_ARTIFACT_BUCKET     = "${aws_s3_bucket.prm-codebuild-infra-artifact.arn}"
    PRM_CODEBUILD_GPPORTAL_ARTIFACT_BUCKET  = "${aws_s3_bucket.prm-codebuild-gp-portal-artifact.arn}"
    PRM_CODEBUILD_IMAGE_PIPELINE_BUCKET     = "${aws_s3_bucket.prm-codebuild-image-artifact.arn}"
  }
}

