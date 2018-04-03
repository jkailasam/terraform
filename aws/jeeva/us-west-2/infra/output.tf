output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "caller_arn" {
  value = "${data.aws_caller_identity.current.arn}"
}

output "caller_user" {
  value = "${data.aws_caller_identity.current.user_id}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc0.id}"
}

output "igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}

output "Bastion_IP_address" {
  value = "${aws_instance.bastion-nat.*.public_ip}"
}

output "pri-sn-ids" {
  description = "IDs of the Private Subnets"
  value       = "${aws_subnet.private-subnet.*.id}"
}

output "pub-sn-ids" {
  description = "IDs of the Public Subnets"
  value       = ["${aws_subnet.public-subnet.*.id}"]
}

output "public_route_table_id" {
  value = "${aws_route_table.public.id}"
}

output "public_route_table_association" {
  value = "${aws_route_table_association.pub_rt_association.*.id}"
}

output "private_route_table_association" {
  value = "${aws_route_table_association.pri_rt_association.*.id}"
}

output key_pair_jkailasam {
  value = "${aws_key_pair.jkailasam.key_name}"
}

output "aws_cloudwatch_log_group_arn" {
  value = "${aws_cloudwatch_log_group.cwlg.arn}"
}

output "sg_default" {
  value = "${aws_default_security_group.default.id}"
}

output "sg_mysql" {
  value = "${aws_security_group.mysql.id}"
}

output "sg_FrontEnd" {
  value = "${aws_security_group.FrontEnd.id}"
}

output "ct_cw_role_arn" {
  value = "${aws_iam_role.ct-cw-role.arn}"
}

output "config_role_arn" {
  value = "${aws_iam_role.config_role.arn}"
}

output "bastion_profile_name" {
  value = "${aws_iam_instance_profile.bastion-profile.name}"
}
