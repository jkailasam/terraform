# Create a Role for NAT Instance
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
  name = "bastion-profile"
  role = "${aws_iam_role.bastion-role.name}"
}

# Create a config Role to use with aws config
resource "aws_iam_role" "config_role" {
  name = "aws-config-role"
  path = "/service-role/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "config.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

# Create a policy to attach to the config role
resource "aws_iam_policy" "config-bucket-policy" {
  name        = "config-bucket-policy"
  path        = "/"
  description = "Policy for aws config to write to s3 bucket"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject*"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
            ],
            "Condition": {
                "StringLike": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketAcl"
            ],
            "Resource": "arn:aws:s3:::${var.bucket_name}"
        }
    ]
}
EOF
}

# attach policies to the config role
resource "aws_iam_policy_attachment" "config-attach" {
  name       = "config-attach"
  roles      = ["${aws_iam_role.config_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_iam_policy_attachment" "config-bucket-attach" {
  name       = "bucket-policy-attach"
  roles      = ["${aws_iam_role.config_role.name}"]
  policy_arn = "${aws_iam_policy.config-bucket-policy.arn}"
}

# Create cloudtrail role to send cloudtrail events to cloudwatch 
resource "aws_iam_role" "ct-cw-role" {
  name = "CloudTrail_CloudWatchLogs_Role"
  path = "/service-role/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "cloudtrail.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

# Create a policy to attache cloudtrail-cloudwatch role
resource "aws_iam_policy" "ct-cw-policy" {
  name        = "cloudtrail-cloudwatch-policy"
  path        = "/service-policy/"
  description = "Policy for aws config to write to s3 bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream2014110",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream"
      ],
      "Resource": [
        "arn:aws:logs:us-west-2:${data.aws_caller_identity.current.account_id}:log-group:${var.account_name}-trail-lg:log-stream:${data.aws_caller_identity.current.account_id}_CloudTrail_us-west-2*",
        "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:${var.account_name}-trail-lg:log-stream:${data.aws_caller_identity.current.account_id}_CloudTrail_us-east-1*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents20141101",
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:us-west-2:${data.aws_caller_identity.current.account_id}:log-group:${var.account_name}-trail-lg:log-stream:${data.aws_caller_identity.current.account_id}_CloudTrail_us-west-2*",
        "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:${var.account_name}-trail-lg:log-stream:${data.aws_caller_identity.current.account_id}_CloudTrail_us-east-1*"
      ]
    }
  ]
}
EOF
}

# attach  the policy to the role
resource "aws_iam_policy_attachment" "ct-cw-attach" {
  name       = "cloudtrail-cloudwatch-attach"
  roles      = ["${aws_iam_role.ct-cw-role.name}"]
  policy_arn = "${aws_iam_policy.ct-cw-policy.arn}"
}
