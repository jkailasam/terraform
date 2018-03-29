resource "aws_subnet" "private-subnet" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.cidr_block}"
  availability_zone = "${var.availability_zone}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
  tags {
    "Name" = "${var.sn_type}-${element(var.azs, count.index)}-sn"
  }
}
output "sn_id" {
  description = "The ID of the Subnet"
  value       = "${aws_subnet.private-subnet.*.id}"
}
