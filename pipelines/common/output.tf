output "prm-codebuild-infra-artifact-bucket" {
  value       = aws_s3_bucket.prm-codebuild-infra-artifact.bucket
  description = "Bucket for infra artefects"
}

output "prm-codebuild-gp-portal-artifact" {
  value       = aws_s3_bucket.prm-codebuild-gp-portal-artifact.bucket
  description = "Bucket for GP Portal artefects"
}

output "prm-codebuild-pds-adaptor-artifact" {
  value       = aws_s3_bucket.prm-codebuild-pds-adaptor-artifact.bucket
  description = "Bucket for PDS Adaptor artefects"
}

output "prm-codebuild-gp2gp-adaptor-artifact" {
  value       = aws_s3_bucket.prm-codebuild-pds-adaptor-artifact.bucket
  description = "Bucket for PDS Adaptor artefects"
}

output "prm-codebuild-ehr-repo-artifact" {
  value       = aws_s3_bucket.prm-codebuild-ehr-repo-artifact.bucket
  description = "Bucket for PDS Adaptor artefects"
}

output "prm-codebuild-image-artifact" {
  value       = aws_s3_bucket.prm-codebuild-image-artifact.bucket
  description = "Bucket for Image Pipeline artefects"
}

output "prm-build-monitor-files" {
  value       = aws_s3_bucket.prm-buildmonitor-build-files.bucket
  description = "Bucket for Build Monitor Ansible Files"
}

output "gp_portal_ecr_repo_name" {
  value       = aws_ecr_repository.gp-portal-ecr-repo.name
}

output "pds_adaptor_ecr_repo_name" {
  value       = aws_ecr_repository.pds-adaptor-ecr-repo.name
}

output "gp2gp_adaptor_ecr_repo_name" {
  value       = aws_ecr_repository.gp2gp-adaptor-ecr-repo.name
}

output "ehr_repo_ecr_repo_name" {
  value       = aws_ecr_repository.ehr-repo-ecr-repo.name
}

output "terraform012_ecr_repo_name" {
  value       = aws_ecr_repository.terraform-012-image.name
}

output "node_ecr_repo_name" {
  value       = aws_ecr_repository.node-image.name
}


output "codepipeline_generic_role_arn" {
  value       = aws_iam_role.deductions-codepipeline-generic-role.arn
}

output "codebuild_project_generic_role_arn" {
  value       = aws_iam_role.deductions-codebuild-project-generic-role.arn
}

output "codebuild_role_arn" {
  value       = aws_iam_role.codebuild-role.arn
}