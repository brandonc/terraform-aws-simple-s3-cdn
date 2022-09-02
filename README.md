#  Simple S3 CDN Terraform Module

A minimally-configurable Route53-S3-CloudFront CDN with an Amazon Issued SSL Certificate.

Among other things, this module creates a Route53 A record for the specified domain name, and the domain name must exist as a Route53 zone.

## Security Notes

The S3 bucket is configured to allow access _only from CloudFront_, but all assets can be read publicly, globally, without restriction through CloudFront.

The CDN can only be accessed via SSL.

## Behavior Notes

The S3 origin does not function as a website. The intent is to host cacheable assets only.

The CDN distribution is intended to be immutable, so all assets are given a very long cache ttl of 1 year. Query string parameters, cookies, and headers are ignored and not forwarded.

By default, only US and Europe edge locations are selected for the CDN distribution. Change the price_class variable to "PriceClass_All" to enable global edge distribution

## Running Tests

Testing is achieved using test assertions built into a real config that uses the module. Just try to apply it:

0. `terraform -chdir test init`
1. `terraform -chdir test apply -auto-approve`
2. `terraform -chdir test destroy -auto-approve`
