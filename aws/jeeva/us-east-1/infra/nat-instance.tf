#Find the AMI of NAT Instance
data "aws_ami" "nat_ami" {
  most_recent      = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-hvm*"]
  }
}


# Create a Role
resource "aws_iam_role" "bastion-role" {
  name = "bastion-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

# Create a Policy
resource "aws_iam_policy" "bastion-policy" {
  name        = "bastion-policy"
  path        = "/"
  description = "Policy for Bastion systems"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "route53:ListTagsForResources",
                "route53:GetHealthCheckStatus",
                "route53:GetHostedZone",
                "route53:ListHostedZones",
                "route53:ChangeResourceRecordSets",
                "route53:ListResourceRecordSets",
                "route53:ListGeoLocations",
                "route53:GetHostedZoneCount",
                "route53:ListHostedZonesByName"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# attach Policy to a role
resource "aws_iam_policy_attachment" "bastion-attach" {
  name       = "bastion-attache"
  roles      = ["${aws_iam_role.bastion-role.name}"]
  policy_arn = "${aws_iam_policy.bastion-policy.arn}"
}

# Create Instance Profile and assign role
resource "aws_iam_instance_profile" "bastion-profile" {
  name  = "bastion-profile"
  role = "${aws_iam_role.bastion-role.name}"
}

# Create a Keypair
resource "aws_key_pair" "jkailasam" {
  key_name   = "jkailasam"
  public_key = "${var.public_key}"
}

# Spinup the NAT instance
resource "aws_instance" "bastion-nat" {
  ami           = "${data.aws_ami.nat_ami.id}"
  instance_type = "t2.nano"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.public-subnet.0.id}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  key_name = "${aws_key_pair.jkailasam.key_name}"
  private_ip = "${var.nat_ip}"
  source_dest_check = false
  iam_instance_profile = "${aws_iam_instance_profile.bastion-profile.name}"
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

output "public_ip" {
  value = "${aws_instance.bastion-nat.public_ip}"
}