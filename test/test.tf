terraform {
  required_providers {
    testing = {
      source = "apparentlymart/testing"
      version = "0.0.2"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

locals {
  testing_domain = "testing"
  domain = "boxcutter.click"
}

resource "aws_route53_zone" "harness" {
  name = "${local.testing_domain}.${local.domain}"
}

data "aws_route53_zone" "upstream" {
  name = local.domain
}

resource "aws_route53_record" "harness-ns" {
  zone_id = data.aws_route53_zone.upstream.zone_id
  name    = local.testing_domain
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.harness.name_servers
}

resource "aws_s3_object" "fixture" {
  bucket = "testing-boxcutter-click"
  key    = "object.txt"
  source = "${path.root}/fixtures/object.txt"
  content_type = "text/plain"

  depends_on = [
    module.mut
  ]
}

module "mut" {
  source = "../"

  bucket_name = "testing-boxcutter-click"
  domain_name = "${local.testing_domain}.${local.domain}"
  zone_depends_on = [
    aws_route53_zone.harness.name,
    aws_route53_record.harness-ns.fqdn
  ]
}

data "http" "cloudfront_object" {
  url = "https://${aws_route53_zone.harness.name}/${aws_s3_object.fixture.key}"
}

data "testing_assertions" "cloudfront_works" {
  subject = "Cloudfront distribution"

  equal "contents" {
    statement = "got the expected object"

    got = data.http.cloudfront_object.response_body
    want = file(aws_s3_object.fixture.source)
  }
}
