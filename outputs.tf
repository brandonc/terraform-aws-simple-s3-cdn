output "s3_arn" {
  description = "ARN of the S3 origin bucket"
  value       = aws_s3_bucket.origin.arn
}

output "cloudfront_arn" {
  description = "ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn_distribution.arn
}
