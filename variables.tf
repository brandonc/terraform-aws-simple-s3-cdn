variable "bucket_name" {
  description = "The name of the s3 bucket to create. Must be unique."
  type = string
}

variable "domain_name" {
  description = "The domain name of the CDN host. Subdomains are allowed. Example: corporatewebsiteassets.net"
  type = string
}

variable "price_class" {
  description = <<EOF
The CloudFront price_class (https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#price_class) associated with the distribution:

"PriceClass_All": All edge locations
"PriceClass_200": North America, Europe, Asia, Middle East, and Africa
"PriceClass_100": North America and Europe edge locations
  EOF
  type = string
  default = "PriceClass_100"
  validation {
    condition = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "Value must be a valid PriceClass value. See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#price_class for details."
  }
}
