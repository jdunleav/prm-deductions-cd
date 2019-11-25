data "aws_ssm_parameter" "inbound_ips" {
    name = "/NHS/${var.environment}-${data.aws_caller_identity.current.account_id}/tf/inbound_ips"
}

data "aws_ssm_parameter" "deductions_private_bastion" {
    name = "/NHS/${var.environment}-${data.aws_caller_identity.current.account_id}/tf/deductions_private_bastion"
}

data "aws_ssm_parameter" "root_zone_id" {
  name = "/NHS/deductions-${data.aws_caller_identity.current.account_id}/root_zone_id"
}

data "aws_caller_identity" "current" {}


data "archive_file" "buildmonitor_install_zip" {
  type        = "zip"
  source_file = "${path.module}/templates/ansible-playbook-aws-install-docker.yml"
  output_path = "${path.module}/artifacts/ansible-template.zip"
}