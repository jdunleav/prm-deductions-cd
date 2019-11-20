resource "aws_codepipeline" "deductions-pds-adaptor" {
  name     = "deductions-pds-adaptor"
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
        Repo                 = "prm-deductions-pds-adaptor"
        Branch               = "master"
        OAuthToken           = "${var.github_token_value}"
        PollForSourceChanges = "true"
      }
    }
  } 

  stage {
    name = "unit-test"

    action {
      name            = "unit-test-pds-adaptor"
      category        = "Test"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source"]

      configuration = {
        ProjectName = "${aws_codebuild_project.prm-unit-test-pds-adaptor.name}"
      }
    }
  }

  stage {
    name = "build-docker-image"  
    action {
      name            = "build-pds-adaptor-image"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source"]  
      configuration =  {
        ProjectName = "${aws_codebuild_project.prm-build-pds-adaptor-image.name}"
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
        ProjectName = "${aws_codebuild_project.prm-deploy-pds-adaptor.name}"
      }
    }
  }
}