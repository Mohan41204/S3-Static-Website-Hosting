output "s3_bucket_name" {
  value = module.s3_bucket.bucket_name
}

output "root_website_url" {
  description = "The public URL of the S3 static website"
  value       = module.s3_bucket.website_url
}