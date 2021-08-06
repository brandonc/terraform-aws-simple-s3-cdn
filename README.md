#  Simple S3 CDN Terraform Module

A minimally-configurable Route53-S3-CloudFront CDN with an Amazon Issued SSL Certificate.

Among other things, this module creates a DNS zone, hosted by Route53, using the specified domain name. It is up to the implementer to set the nameservers of the specified domain to the name servers dynamically set by the Route53 DNS Zone. IMPORTANT: It's necessary to update your nameservers for the chosen `domain_name` to the nameservers generated indicated by the _new_ zone in Route53. Terraform will appear to hang for some time while creating `aws_acm_certificate_validation.cert` until DNS propagates from nameservers on registrar to Route53. As long as your DNS is resolved by Route53 the validation will succeed.

## Security Notes

The S3 bucket is configured to only allow access _only from CloudFront_, but all assets can be read publicly, globally, without restriction through CloudFront.

The CDN can only be accessed via SSL.

## Behavior Notes

The S3 origin does not function as a website. The intent is to host cacheable assets only.

The CDN distribution is intented to be immutable, so all assets are given a very long cache ttl of 1 year. Query string parameters, cookies, and headers are ignored and not forwarded.

By default, only US and Europe edge locations are selected for the CDN distribution. Change the price_class variable to "PriceClass_All" to enable global edge distribution
