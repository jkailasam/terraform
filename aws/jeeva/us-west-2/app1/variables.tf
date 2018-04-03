################ Provicer Info ####################
variable "profile" {
  default = "jeeva"
  description = "AWS profile to use authenticate"
}

variable "credential_file" {
  default = "/Users/jkailasam/.aws/credentials"
  description = "AWS Credentials file"
}

variable "region" {
  default = "us-west-2"
}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.credential_file}"
  profile                 = "${var.profile}"
}

terraform {
  backend "s3" {}
}

###########################################

variable app1_desired_capacity  {
  default = 0
}