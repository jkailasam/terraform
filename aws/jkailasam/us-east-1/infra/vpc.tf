/* Set the Provider for terraform */
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

# Create VPC
resource "aws_vpc" "vpc0" {
    cidr_block = "${var.vpc0-cidr}"
   #### this 2 true values are for use the internal vpc dns resolution
    enable_dns_support = true
    enable_dns_hostnames = true
    tags {
      Name = "VPC0"
    }
}

# Declare the data source
data "aws_availability_zones" "available" {}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
   vpc_id = "${aws_vpc.vpc0.id}"
    tags {
        Name = "IGW for vpc0"
    }
}

# Create Network ACL
resource "aws_network_acl" "all" {
   vpc_id = "${aws_vpc.vpc0.id}"
    egress {
        protocol = "-1"
        rule_no = 2
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol = "-1"
        rule_no = 1
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    tags {
        Name = "open acl"
    }
}


# Create public Subnets
resource "aws_subnet" "vpc0-public-1c" {
  vpc_id = "${aws_vpc.vpc0.id}"
  cidr_block = "${var.vpc0-public-1c-cidr}"
  tags {
        Name = "vpc0-public-1c"
  }
 availability_zone = "${data.aws_availability_zones.available.names[2]}"
}

resource "aws_subnet" "vpc0-public-1d" {
  vpc_id = "${aws_vpc.vpc0.id}"
  cidr_block = "${var.vpc0-public-1d-cidr}"
  tags {
        Name = "vpc0-public-1d"
  }
 availability_zone = "${data.aws_availability_zones.available.names[3]}"
}

resource "aws_subnet" "vpc0-public-1e" {
  vpc_id = "${aws_vpc.vpc0.id}"
  cidr_block = "${var.vpc0-public-1e-cidr}"
  tags {
        Name = "vpc0-public-1e"
  }
 availability_zone = "${data.aws_availability_zones.available.names[4]}"
}

# Create Private Subnets
resource "aws_subnet" "vpc0-private-1c" {
  vpc_id = "${aws_vpc.vpc0.id}"
  cidr_block = "${var.vpc0-private-1c-cidr}"
  tags {
        Name = "vpc0-private-1c"
  }
 availability_zone = "${data.aws_availability_zones.available.names[2]}"
}

resource "aws_subnet" "vpc0-private-1d" {
  vpc_id = "${aws_vpc.vpc0.id}"
  cidr_block = "${var.vpc0-private-1d-cidr}"
  tags {
        Name = "vpc0-private-1d"
  }
 availability_zone = "${data.aws_availability_zones.available.names[3]}"
}

resource "aws_subnet" "vpc0-private-1e" {
  vpc_id = "${aws_vpc.vpc0.id}"
  cidr_block = "${var.vpc0-private-1e-cidr}"
  tags {
        Name = "vpc0-private-1e"
  }
 availability_zone = "${data.aws_availability_zones.available.names[4]}"
}

# Create Public Route table 
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


# Create a Network Interface for NAT instance
/*resource "aws_network_interface" "nat-nic" {
  subnet_id       = "${aws_subnet.vpc0-public-1c.id}"
  private_ips     = ["${var.nat_ip}"]
  security_groups = ["${aws_security_group.bastion.id}"]
}
*/

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc0.id}"
  tags {
      Name = "Private"
  }
  route {
        cidr_block = "0.0.0.0/0"
        network_interface_id = "${aws_instance.bastion-nat.network_interface_id }"
        #network_interface_id = "${aws_network_interface.nat-nic.id}"
  }
}

/* NAT Gateway 
resource "aws_eip" "forNat" {
    vpc      = true
}

resource "aws_nat_gateway" "PublicAZA" {
    allocation_id = "${aws_eip.forNat.id}"
    subnet_id = "${aws_subnet.PublicAZA.id}"
    depends_on = ["aws_internet_gateway.gw"]
}
*/


# Associate Routing table to Poublic Subnets
resource "aws_route_table_association" "vpc0-public-1c" {
    subnet_id = "${aws_subnet.vpc0-public-1c.id}"
    route_table_id = "${aws_route_table.public.id}"
}

# Associate Routing table to Poublic Subnets
resource "aws_route_table_association" "vpc0-public-1d" {
    subnet_id = "${aws_subnet.vpc0-public-1d.id}"
    route_table_id = "${aws_route_table.public.id}"
}

# Associate Routing table to Poublic Subnets
resource "aws_route_table_association" "vpc0-public-1e" {
    subnet_id = "${aws_subnet.vpc0-public-1e.id}"
    route_table_id = "${aws_route_table.public.id}"
}


# Associate Routing table to Private Subnets
resource "aws_route_table_association" "vpc0-private-1c" {
    subnet_id = "${aws_subnet.vpc0-private-1c.id}"
    route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "vpc0-private-1d" {
    subnet_id = "${aws_subnet.vpc0-private-1d.id}"
    route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "vpc0-private-1e" {
    subnet_id = "${aws_subnet.vpc0-private-1e.id}"
    route_table_id = "${aws_route_table.private.id}"
}
