resource "aws_s3_bucket_object" "object" {
  bucket = "prm-327778747031-buildmonitor-build-files"
  key    = "ansible-template.zip"
  source = data.archive_file.buildmonitor_install_zip.output_path
}