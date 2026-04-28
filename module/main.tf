resource "aws_s3_bucket" "s3" {
  bucket = var.s3

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "versioning" { 
    bucket = aws_s3_bucket.s3.id 
    versioning_configuration { status = "Enabled" } 
}

resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls   = var.acl
  block_public_policy = var.acl
  ignore_public_acls  = var.acl
  restrict_public_buckets = var.acl
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.s3.id

  depends_on = [aws_s3_bucket_public_access_block.allow_public]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.s3.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.s3.id
  key    = var.file
  source = "./website/index.html"
  content_type = "text/html"

  depends_on = [aws_s3_bucket_policy.public_read]

}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.s3.id

  index_document {
    suffix = var.file
  }
}