## Configure the remote state
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "s3-jkailasam-terraform"
    key = "jeeva/us-west-2/infra/terraform.tfstate"    
    region = "us-west-2"
    profile = "jkailasam"
  }
}

## Find the latest Ubuntu Image
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# Create a autoscaling Launch Configuration
resource "aws_launch_configuration" "app1_as_conf" {
  name_prefix   = "app1-"
  image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.nano"
  #iam_instance_profile = "${aws_iam_instance_profile.bastion-profile.name}"
  key_name = "${data.terraform_remote_state.vpc.key_pair_jkailasam}"
  security_groups = ["${data.terraform_remote_state.vpc.sg_default}"]
  root_block_device {
    volume_type = "standard"
    volume_size = 8
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app1" {
  name = "app1-asg"
  launch_configuration = "${aws_launch_configuration.app1_as_conf.name}"
  vpc_zone_identifier  = ["${data.terraform_remote_state.vpc.pri-sn-ids}"]
  min_size = 0
  max_size = 5
  desired_capacity = "${var.app1_desired_capacity}"

  lifecycle {
    create_before_destroy = true
  }
}