resource "aws_s3_bucket" "buc" {
  acl           = "public-read"
  bucket_prefix = "playground${var.reason}"
  tags = {
    Name    = var.PlaygroundName
    Purpose = var.purpose
    Reason  = var.reason
  }
}