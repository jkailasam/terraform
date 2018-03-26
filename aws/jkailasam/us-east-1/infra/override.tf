provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/jkailasam/.aws/credentials"
  profile                 = "jkailasam"
}

variable "nat_ip" {
  default = "10.10.16.10"
}