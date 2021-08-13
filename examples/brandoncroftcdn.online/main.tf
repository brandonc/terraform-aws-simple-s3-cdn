provider "aws" {
  region = "us-west-2"
}

module "brandoncroftcdn-online" {
  source = "../../"

  bucket_name = "brandonc-cdn"
  domain_name = "brandoncroftcdn.online"
}
