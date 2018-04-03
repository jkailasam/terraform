# List the current account, caller arn and userid
data "aws_caller_identity" "current" {}

# Create VPC
resource "aws_vpc" "vpc0" {
  cidr_block           = "${lookup(var.cidr, "vpc")}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "vpc0"
  }
}

# tag the default route_table of the vpc
resource "aws_default_route_table" "vpc0" {
  default_route_table_id = "${aws_vpc.vpc0.default_route_table_id}"

  tags {
    Name = "vpc0"
  }
}

# Create Network ACL for VPC
resource "aws_network_acl" "all" {
  vpc_id = "${aws_vpc.vpc0.id}"

  egress {
    protocol   = "-1"
    rule_no    = 2
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 1
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags {
    Name = "open acl"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc0.id}"

  tags {
    Name = "IGW for vpc0"
  }
}

# Create Private Subnets based on az and cidr variables
resource "aws_subnet" "private-subnet" {
  vpc_id                  = "${aws_vpc.vpc0.id}"
  count                   = "${length(var.azs)}"
  cidr_block              = "${cidrsubnet(lookup(var.cidr, "pri_sn"), 3, count.index)}"
  availability_zone       = "${element( var.azs, count.index)}"
  map_public_ip_on_launch = false

  tags {
    "Name" = "private-${element(var.azs, count.index)}-sn"
  }
}

# Create Public Subnets based on az and cidr variables
resource "aws_subnet" "public-subnet" {
  vpc_id                  = "${aws_vpc.vpc0.id}"
  count                   = "${length(var.azs)}"
  cidr_block              = "${cidrsubnet(lookup(var.cidr, "pub_sn"), 3, count.index)}"
  availability_zone       = "${element( var.azs, count.index)}"
  map_public_ip_on_launch = false

  tags {
    "Name" = "public-${element(var.azs, count.index)}-sn"
  }
}

# Create Public route table
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc0.id}"

  tags {
    Name = "Public"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

# Create Private subnet Route table
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc0.id}"

  tags {
    Name = "Private"
  }

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.bastion-nat.id}"

    #network_interface_id = "${aws_instance.bastion-nat.network_interface_id }"
    #network_interface_id = "${aws_network_interface.nat-nic.id}"
  }

  depends_on = ["aws_instance.bastion-nat"]
}

# Associate Routing table to Public Subnets
resource "aws_route_table_association" "pub_rt_association" {
  count          = "${length(var.azs)}"
  subnet_id      = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

# Associate Routing Table to Private subnets
resource "aws_route_table_association" "pri_rt_association" {
  count          = "${length(var.azs)}"
  subnet_id      = "${element(aws_subnet.private-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

# Create a Keypair
resource "aws_key_pair" "jkailasam" {
  key_name   = "jkailasam"
  public_key = "${var.public_key}"
}
