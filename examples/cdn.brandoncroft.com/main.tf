# terraform {
#   backend "remote" {
#     hostname = "tfcdev-5839ba17.ngrok.io"
#     organization = "hashicorp"

#     workspaces {
#       name = "example-cdn-brandoncroft-com"
#     }
#   }
# }

provider "aws" {
  region = "us-west-2"
}

module "cdn-brandoncroft-com" {
  source = "../../"

  bucket_name = "brandonc-cdn"
  domain_name = "cdn.brandoncroft.com"
}
