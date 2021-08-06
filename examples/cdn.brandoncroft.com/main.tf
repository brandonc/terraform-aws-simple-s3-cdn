provider "aws" {
  region = "us-west-2"
}

module "cdn-brandoncroft-com" {
  source = "../../"

  bucket_name = "brandonc-cdn"
  domain_name = "brandoncroftcdn.online"
}
