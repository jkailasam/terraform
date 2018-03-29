resource "aws_vpc" "vpc0" {
    cidr_block = "${var.cidr_block}"
   #### this 2 true values are for use the internal vpc dns resolution
    enable_dns_support = "${var.enable_dns_support}"
    enable_dns_hostnames = "${var.enable_dns_hostnames}"
    tags = "${var.tags}"
}

resource "aws_default_route_table" "vpc0" {
  default_route_table_id = "${aws_vpc.vpc0.default_route_table_id}"
  tags  = "${var.tags}"
}



output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${aws_vpc.vpc0.id}"
}

output "def_sg_id" {
  description = "The default Security Group ID of the VPC"
  value       = "${aws_vpc.vpc0.default_security_group_id}"
}