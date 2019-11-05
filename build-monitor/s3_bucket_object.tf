resource "aws_s3_bucket_object" "object" {
  bucket = "prm-327778747031-buildmonitor-build-files"
  key    = "ansible-template.zip"
  source = "${data.archive_file.buildmonitor_install_zip.output_path}"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
#   etag = "${filemd5("path/to/file")}"
}