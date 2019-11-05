resource "aws_iam_role" "buildmonitor-role" {
  name = "BuildMonitorRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "buildmonitor-profile" {
  name = "build-monitor-instance-profile"
  role = "${aws_iam_role.buildmonitor-role.name}"
}

resource "aws_iam_role_policy_attachment" "buildmonitor-role-attach-1" {
  role       = "${aws_iam_role.buildmonitor-role.name}"
  policy_arn = "${data.aws_iam_policy.AmazonEC2ContainerRegistryReadOnly.arn}"
}

resource "aws_iam_role_policy_attachment" "buildmonitor-role-attach-2" {
  role       = "${aws_iam_role.buildmonitor-role.name}"
  policy_arn = "${data.aws_iam_policy.AmazonS3ReadOnlyAccess.arn}"
}

resource "aws_iam_role_policy_attachment" "buildmonitor-role-attach-3" {
  role       = "${aws_iam_role.buildmonitor-role.name}"
  policy_arn = "${data.aws_iam_policy.AWSCodePipelineFullAccess.arn}"
}

data "aws_iam_policy" "AmazonEC2ContainerRegistryReadOnly" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy" "AmazonS3ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

data "aws_iam_policy" "AWSCodePipelineFullAccess" {
  arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
}

# resource "aws_iam_role_policy" "buildmonitor-policy" {
#   name = "BuildMonitorPolicy"
#   role = "${aws_iam_role.buildmonitor-role.id}"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "s3:*"
#       ],
#       "Effect": "Allow",
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }