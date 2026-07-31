output "SERVER_IP" {
  value       = aws_instance.ubuntu.public_ip
  description = "Public IP address of the Ubuntu instance"
}

output "MYSQL_DATABASE" {
  description = "The name of the database created inside MySQL"
  value       = aws_db_instance.blog-app-mysql.db_name
}

output "MYSQL_HOST" {
  description = "The connection endpoint/host for your RDS instance"
  value       = aws_db_instance.blog-app-mysql.address
}

output "MYSQL_USER" {
  description = "The master username for database login"
  value       = aws_db_instance.blog-app-mysql.username
}

output "MYSQL_PASSWORD" {
  description = "The dynamically generated master password"
  value       = random_password.db_password.result
  sensitive   = true
}

output "AWS_BUCKET_NAME" {
  description = "The globally unique name of the S3 bucket"
  value       = aws_s3_bucket.blog-application.id
}

output "AWS_BUCKET_URL" {
  description = "The public base URL of the S3 bucket"
  value       = "https://${aws_s3_bucket.blog-application.id}.s3.amazonaws.com"
}

output "AWS_ACCESS_KEY_ID" {
  description = "The access key ID for your application upload code"
  value       = aws_iam_access_key.uploader_key.id
}

output "AWS_SECRET_ACCESS_KEY" {
  description = "The secret access key for your application upload code"
  value       = aws_iam_access_key.uploader_key.secret
  sensitive   = true
}
