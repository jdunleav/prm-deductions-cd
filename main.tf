module "common" {
    source                              = "./pipelines/common/"
    environment                         = var.environment
    aws_region                          = var.aws_region
    codebuild_role                      = var.codebuild_role
    codepipeline_generic_role           = var.codepipeline_generic_role
    codebuild_project_generic_role      = var.codebuild_project_generic_role
    caller_identity_current_account_id  = data.aws_caller_identity.current.account_id
}

module "deductions-build-monitor" {
    source                              = "./build-monitor/"
    environment                         = var.environment
    aws_region                          = var.aws_region
    component_name                      = var.build_monitor_component_name

}

module "deductions-build-images" {
    source                              = "./pipelines/deductions-build-images/"
    environment                         = var.environment
    aws_region                          = var.aws_region

    role_arn                            = module.common.codebuild_role_arn
    artifact_bucket                     = module.common.prm-codebuild-image-artifact

    terraform_ecr_repo_name             = module.common.terraform012_ecr_repo_name
    node_ecr_repo_name                  = module.common.node_ecr_repo_name

    codepipeline_generic_role_arn       = module.common.codepipeline_generic_role_arn
    github_token_value                  = data.aws_ssm_parameter.github_token.value
    service_role                        = module.common.codebuild_project_generic_role_arn

    caller_identity_current_account_id  = data.aws_caller_identity.current.account_id
}

module "deductions-infra" {
    source                              = "./pipelines/deductions-infra/"
    environment                         = var.environment
    aws_region                          = var.aws_region

    role_arn                            = module.common.codebuild_role_arn
    artifact_bucket                     = module.common.prm-codebuild-infra-artifact-bucket

    codepipeline_generic_role_arn       = module.common.codepipeline_generic_role_arn
    github_token_value                  = data.aws_ssm_parameter.github_token.value
    service_role                        = module.common.codebuild_project_generic_role_arn

    caller_identity_current_account_id  = data.aws_caller_identity.current.account_id
}

module "deductions-gp-portal" {
    source                              = "./pipelines/deductions-gp-portal/"
    environment                         = var.environment
    aws_region                          = var.aws_region

    role_arn                            = module.common.codebuild_role_arn
    artifact_bucket                     = module.common.prm-codebuild-gp-portal-artifact

    ecr_repo_name                       = module.common.gp_portal_ecr_repo_name

    codepipeline_generic_role_arn       = module.common.codepipeline_generic_role_arn
    github_token_value                  = data.aws_ssm_parameter.github_token.value
    service_role                        = module.common.codebuild_project_generic_role_arn

    caller_identity_current_account_id  = data.aws_caller_identity.current.account_id
}

module "deductions-pds-adaptor" {
    source                              = "./pipelines/deductions-pds-adaptor/"
    environment                         = var.environment
    aws_region                          = var.aws_region

    role_arn                            = module.common.codebuild_role_arn
    artifact_bucket                     = module.common.prm-codebuild-pds-adaptor-artifact

    ecr_repo_name                       = module.common.pds_adaptor_ecr_repo_name

    codepipeline_generic_role_arn       = module.common.codepipeline_generic_role_arn
    github_token_value                  = data.aws_ssm_parameter.github_token.value
    service_role                        = module.common.codebuild_project_generic_role_arn

    caller_identity_current_account_id  = data.aws_caller_identity.current.account_id
}

module "deductions-gp2gp-adaptor" {
    source                              = "./pipelines/deductions-gp2gp-adaptor/"
    environment                         = var.environment
    aws_region                          = var.aws_region

    role_arn                            = module.common.codebuild_role_arn
    artifact_bucket                     = module.common.prm-codebuild-gp2gp-adaptor-artifact

    ecr_repo_name                       = module.common.gp2gp_adaptor_ecr_repo_name

    codepipeline_generic_role_arn       = module.common.codepipeline_generic_role_arn
    github_token_value                  = data.aws_ssm_parameter.github_token.value
    service_role                        = module.common.codebuild_project_generic_role_arn

    caller_identity_current_account_id  = data.aws_caller_identity.current.account_id
}