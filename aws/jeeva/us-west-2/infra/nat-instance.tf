#Find the AMI of NAT Instance
data "aws_ami" "nat_ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-hvm*"]
  }
}

# Spinup the NAT instance
resource "aws_instance" "bastion-nat" {
  count                       = "${var.nat_count}"
  ami                         = "${data.aws_ami.nat_ami.id}"
  instance_type               = "t2.nano"
  associate_public_ip_address = "true"
  subnet_id                   = "${aws_subnet.public-subnet.0.id}"
  vpc_security_group_ids      = ["${aws_security_group.bastion.id}"]
  key_name                    = "${aws_key_pair.jkailasam.key_name}"
  private_ip                  = "${var.nat_ip}"
  source_dest_check           = false
  iam_instance_profile        = "${aws_iam_instance_profile.bastion-profile.name}"

  tags {
    Name = "Bastion and NAT Instance"
  }

  root_block_device {
    volume_type = "standard"
    volume_size = 8
  }

  user_data = <<HEREDOC
  #!/bin/bash
  yum update -y
HEREDOC
}
