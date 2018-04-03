# S3 bucket to use with Config and Cloud trail
/*

resource "aws_s3_bucket" "b" {
  bucket = "${var.bucket_name}"
  acl    = "private"
  region = "${var.region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    Name = "cloudtrail-logs"
  }
}

# Apply bucket Policy
resource "aws_s3_bucket_policy" "bp" {
  bucket = "${aws_s3_bucket.b.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheck20131101",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${var.bucket_name}"
    },
    {
      "Sid": "AWSCloudTrailWrite20131101",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": [
        "arn:aws:s3:::${var.bucket_name}/AWSLogs/270394749206/*",
        "arn:aws:s3:::${var.bucket_name}/AWSLogs/689065950067/*"
      ],
      "Condition": { 
        "StringEquals": { 
          "s3:x-amz-acl": "bucket-owner-full-control" 
        }
      }
    },
    {
        "Sid": "DenyUnEncryptedObjectUploads",
        "Effect": "Deny",
        "Principal": "*",
        "Action": "s3:PutObject",
        "Resource": [
          "arn:aws:s3:::${var.bucket_name}/AWSLogs/270394749206/*",
          "arn:aws:s3:::${var.bucket_name}/AWSLogs/689065950067/*"
        ],
        "Condition": {
            "Null": {
                "s3:x-amz-server-side-encryption": "true"
            }
        }
    },
    {
        "Sid": "DenyHttp",
        "Effect": "Deny",
        "Principal": "*",
        "Action": [
            "s3:GetObject",
            "s3:PutObject"
        ],
        "Resource": [
          "arn:aws:s3:::${var.bucket_name}/AWSLogs/270394749206/*",
          "arn:aws:s3:::${var.bucket_name}/AWSLogs/689065950067/*"
        ],
        "Condition": {
            "Bool": {
                "aws:SecureTransport": "false"
            }
        }
    }
  ]
}
POLICY
}

*/

