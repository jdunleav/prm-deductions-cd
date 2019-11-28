resource "aws_codepipeline" "deductions-gp2gp-adaptor" {
  name     = "deductions-gp2gp-adaptor"
  role_arn = var.codepipeline_generic_role_arn 

  artifact_store {
    location = var.artifact_bucket
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
        Repo                 = "prm-deductions-gp2gp-adaptor"
        Branch               = "master"
        OAuthToken           = var.github_token_value
        PollForSourceChanges = "true"
      }
    }
  } 

  stage {
    name = "dependency-check"

    action {
      name            = "dependency-check"
      category        = "Test"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source"]

      configuration = {
        ProjectName = aws_codebuild_project.prm-dependency-check-gp2gp-adaptor.name
      }
    }
  }

  stage {
    name = "unit-test"

    action {
      name            = "unit-test-gp2gp-adaptor"
      category        = "Test"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source"]

      configuration = {
        ProjectName = aws_codebuild_project.prm-unit-test-gp2gp-adaptor.name
      }
    }
  }

  stage {
    name = "build-docker-image"  
    action {
      name            = "build-gp2gp-adaptor-image"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source"]  
      configuration =  {
        ProjectName = aws_codebuild_project.prm-build-gp2gp-adaptor-image.name
      }
    }  
  }

  stage {
    name = "deploy-task-and-app"  
    action {
      name            = "Apply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source"]
      run_order       = 2 
      configuration = {
        ProjectName = aws_codebuild_project.prm-deploy-gp2gp-adaptor.name
      }
    }
  }
}