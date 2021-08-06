locals {
  s3_origin_id = "public-simple-S3-cdn-origin"
}

provider "aws" {
  region = "us-east-1"
  alias = "us_east_1_provider"
}

resource "aws_s3_bucket" "origin" {
  bucket = var.bucket_name
  acl = "public-read"

  policy = <<EOF
{
  "Version":"2008-10-17",
  "Statement":[{
    "Sid":"AllowPublicRead",
    "Effect":"Allow",
    "Principal": {"AWS": "${aws_cloudfront_origin_access_identity.access_id.iam_arn}"},
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::brandonc-public/*"]
  }]
}
  EOF
}

resource "aws_cloudfront_origin_access_identity" "access_id" {
  comment = "Allows ONLY CloudFront to access s3 origin"
}

resource "aws_cloudfront_distribution" "cdn_distribution" {
  origin {
    domain_name = aws_s3_bucket.origin.bucket_regional_domain_name
    origin_id = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.access_id.cloudfront_access_identity_path
    }
  }

  enabled = true
  is_ipv6_enabled = true
  price_class = var.price_class
  aliases = [var.domain_name]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "https-only"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method = "sni-only"
  }
}

resource "aws_acm_certificate" "cert" {
  provider = aws.us_east_1_provider # required for certificates
  domain_name = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "primary_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  zone_id = aws_route53_zone.primary_zone.id
  name = each.value.name
  type = each.value.type
  records = [each.value.record]
  ttl = 60
}

resource "aws_route53_record" "dns" {
  name = var.domain_name
  type = "A"
  zone_id = aws_route53_zone.primary_zone.id

  alias {
    name = aws_cloudfront_distribution.cdn_distribution.domain_name
    zone_id = aws_cloudfront_distribution.cdn_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate_validation" "cert" {
  provider = aws.us_east_1_provider # required for certificates
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
