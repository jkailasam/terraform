# Create a Bastion Security Group
resource "aws_security_group" "bastion" {
  name = "bastion"
  tags {
        Name = "bastion"
  }
  description = "Bastion Security Group"
  vpc_id = "${aws_vpc.vpc0.id}"

  ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["147.92.89.53/32", "72.34.128.250/32"]
  }
  
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      security_groups = ["${aws_vpc.vpc0.default_security_group_id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a security group to open port 80 and 433 to the world
resource "aws_security_group" "FrontEnd" {
  name = "FrontEnd"
  tags {
        Name = "FrontEnd"
  }
  description = "Security Group for Frontend Web applications"
  vpc_id = "${aws_vpc.vpc0.id}"

  ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group to allow communication from instances which has Frontend SG assigned
resource "aws_security_group" "mysql" {
  name = "mysql"
  tags {
        Name = "mysql"
  }
  description = "Security Group to communicate Frontend with DB"
  vpc_id = "${aws_vpc.vpc0.id}"
  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "TCP"
      security_groups = ["${aws_security_group.FrontEnd.id}"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create default Security Group
resource "aws_default_security_group" "default" {
  tags {
    Name = "default"
  }
  vpc_id = "${aws_vpc.vpc0.id}"
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      self = true
      #security_groups = ["${aws_vpc.vpc0.default_security_group_id}"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]

  }  
}