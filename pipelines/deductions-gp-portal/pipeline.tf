resource "aws_codepipeline" "deductions-gp-portal" {
  name     = "deductions-gp-portal"
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
        Repo                 = "prm-deductions-portal-gp-practice"
        Branch               = "master"
        OAuthToken           = "${var.github_token_value}"
        PollForSourceChanges = "true"
      }
    }
  } 

  stage {
    name = "build-docker-image"  
    action {
      name            = "build-gp-portal-image"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source"]  
      configuration =  {
        ProjectName = "${aws_codebuild_project.prm-build-gp-portal-image.name}"
      }
    }  
  }

  stage {
    name = "apply-task-and-deploy-app"  
    action {
      name            = "Apply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source"]
      run_order       = 2 
      configuration = {
        ProjectName = "${aws_codebuild_project.prm-deploy-gp-practice-portal.name}"
      }
    }
  }
}