resource "aws_s3_bucket" "app" {
  bucket = "adam-tf-servian-app2153"
  acl    = "public-read"

  tags = {
    "Name"      = "My bucket"
    Environment = "Dev"
  }

  versioning {
    enabled = true
  }
}