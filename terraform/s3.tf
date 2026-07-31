resource "aws_s3_bucket" "blog-application" {
  bucket_prefix = "blog-application"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.blog-application.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  depends_on = [aws_s3_bucket_public_access_block.public_access]
  bucket     = aws_s3_bucket.blog-application.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.blog-application.arn}/*"
      }
    ]
  })
}

resource "aws_iam_user" "uploader" {
  name = "blog-s3-uploader-user"
}

resource "aws_iam_access_key" "uploader_key" {
  user = aws_iam_user.uploader.name
}

resource "aws_iam_user_policy" "upload_policy" {
  name = "BlogS3UploadPolicy"
  user = aws_iam_user.uploader.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.blog-application.arn}/*"
      }
    ]
  })
}