output "bucket_name" {
  value = aws_s3_bucket.s3.id
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}