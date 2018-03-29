#variable "vpc_name" {}
variable "enable_dns_hostnames" {}
variable "enable_dns_support" {}
variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}
variable "tags" {type = "map"}
variable "cidr_block" {}