resource "aws_codepipeline" "prm-gp-portal-pipeline" {
  name     = "deductions-infra"
  role_arn = "${var.codepipeline_generic_role_arn}"  

  artifact_store {
    location = "${var.artifact_bucket}"
    type     = "S3"
  } 

  stage {
    name = "source" 
    action {
      name             = "GithubSource"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"] 
      configuration = {
        Owner                = "nhsconnect"
        Repo                 = "prm-deductions-infra"
        Branch               = "master"
        # OAuthToken           = "${var.github_token_value}"
        PollForSourceChanges = "true"
      }
    }
  } 
  
  stage {
    name = "apply-infrastructure"  
    action {
      name            = "Apply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source"]
      run_order       = 2 
      configuration = {
        ProjectName = "${aws_codebuild_project.prm-deductions-infra-apply.name}"
      }
    }
  } 
}