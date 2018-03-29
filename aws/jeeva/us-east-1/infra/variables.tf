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
  default = "us-east-1"
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

variable "azs" {
  type = "list"
  default = ["us-east-1c", "us-east-1d", "us-east-1d"]
}

variable "cidr" {
  type= "map"
  default = {
    vpc = "10.10.0.0/20"
    pri_sn = "10.10.0.0/21"
    pub_sn = "10.10.8.0/21"
  }
}

variable "nat_ip" {
  default = "10.10.8.10"
}

variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDc+uM6tLX0En+34xW9SJzGMfyCtS5ymLvYRjioLxQ2yJr4+BKXMRgUJWxpA3klX+cLHwE2dojpsVae71pljGzVeNE4s88LSmcuUnPUgvf3rNWsw0+dmILdeF7JieRphSieI/xkwTXeboMPTXjI8dm8rUrk+SN57uYSg8wYyloWQdg96ZgwGFTFJQUbLhpXSzCcQpMxVjDBl9E1lGkR6T3Ad7w4tATBU0cI0PaU+XhPHmzw0YdDZdEo8XFkIR+g2aJOlBFSdLFPehTdZiByp643rW43LUP81O6A6HxNJixDiQkVaNv2WJjGFBY9PjvGOHFQthCh1j/Hf3BYd2/DLvbh Jeeva's Key"
  description = "Jeeva's Public Key"
}