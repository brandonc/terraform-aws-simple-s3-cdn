output "s3_arn" {
  description = "ARN of the S3 origin bucket"
  value       = aws_s3_bucket.origin.arn
}

output "cloudfront_domain" {
  description = "Domain name of the CDN distribution"
  value       = aws_cloudfront_distribution.cdn_distribution.domain_name
}

output "cloudfront_arn" {
  description = "ARN of the CloudFront distribution"
  value       =  aws_cloudfront_distribution.cdn_distribution.arn
}

output "distribution_domain" {
  description = "Fully qualified domain name of the dns record"
  value       = aws_route53_record.dns.fqdn
}
