output "name" {
  value       = aws_s3_bucket.buc.bucket
  description = "The name of the created bucket"
}