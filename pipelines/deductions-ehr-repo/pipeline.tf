resource "aws_codepipeline" "deductions-ehr-repo" {
  name     = "deductions-ehr-repo"
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
        Repo                 = "prm-deductions-ehr-repository"
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
        ProjectName = aws_codebuild_project.prm-dependency-check-ehr-repo.name
      }
    }
  }

  # stage {
  #   name = "unit-test"

  #   action {
  #     name            = "unit-test-ehr-repo"
  #     category        = "Test"
  #     owner           = "AWS"
  #     provider        = "CodeBuild"
  #     version         = "1"
  #     input_artifacts = ["source"]

  #     configuration = {
  #       ProjectName = aws_codebuild_project.prm-unit-test-ehr-repo.name
  #     }
  #   }
  # }

  stage {
    name = "build-docker-image"  
    action {
      name            = "build-ehr-repo-image"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source"]  
      configuration =  {
        ProjectName = aws_codebuild_project.prm-build-ehr-repo-image.name
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
        ProjectName = aws_codebuild_project.prm-deploy-ehr-repo.name
      }
    }
  }
}