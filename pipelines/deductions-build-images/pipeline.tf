resource "aws_codepipeline" "images-pipeline" {
    name     = "deductions-build-images"
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
          Repo                 = "prm-deductions-cd"
          Branch               = "master"
          # OAuthToken           = "${var.github_token_value}"
          PollForSourceChanges = "true"
        }
      }
    }

    stage {
        name = "build-images"

        action {
          name            = "build-terraform-012-image"
          category        = "Build"
          owner           = "AWS"
          provider        = "CodeBuild"
          version         = "1"
          input_artifacts = ["source"]

          configuration = {
            ProjectName = "${aws_codebuild_project.prm-build-terraform-012-image.name}"
          }
      }    

    action {
        name            = "build-node-image"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        version         = "1"
        input_artifacts = ["source"]

        configuration = {
          ProjectName = "${aws_codebuild_project.prm-build-node-image.name}"
        }
      }
    }
}
