# Create a config recorder
resource "aws_config_configuration_recorder" "cr" {
  name = "${var.region}-recorder"

  recording_group {
    all_supported                 = "true"
    include_global_resource_types = "true"
  }

  role_arn = "${aws_iam_role.config_role.arn}"
}

# Create a config delivery channel
resource "aws_config_delivery_channel" "dc" {
  name = "${var.region}-delivery-channel"

  snapshot_delivery_properties {
    delivery_frequency = "One_Hour"
  }

  s3_bucket_name = "${var.bucket_name}"

  #sns_topic_arn  = "${var.snstopicarn}"
  depends_on = ["aws_config_configuration_recorder.cr"]
}

# Create cloudwatch loggroup
resource "aws_cloudwatch_log_group" "cwlg" {
  name              = "${var.account_name}-trail-lg"
  retention_in_days = 30
}

# Create Cloudtrail trail
resource "aws_cloudtrail" "cloudtrail_default" {
  name                       = "${var.account_name}-trail"
  is_multi_region_trail      = false
  s3_bucket_name             = "${var.bucket_name}"
  enable_logging             = true
  enable_log_file_validation = true
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cwlg.arn}"
  cloud_watch_logs_role_arn  = "${aws_iam_role.ct-cw-role.arn}"

  #sns_topic_name             = "${var.snstopic}"
  # Log all Lamda invocations
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }

  # log all s3 read/write
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }
}
