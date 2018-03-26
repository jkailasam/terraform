# Define where to store the state file
/*data "terraform_remote_state" "network" {
  backend = "s3"
  config {
    bucket = "s3-jkailasam-terraform"
    key    = "network/us-east-1-terraform.tfstate"
    provider = "aws.us-west-2"
  }
}



# Define where to store the state file
data "terraform_remote_state" "network" {
  backend = "s3"
  config {
    bucket = "s3-jkailasam-terraform"
    key    = "network/us-east-1-terraform.tfstate"
    endpoint = "s3.us-west-2.amazonaws.com"
    region = "us-west-2"
    profile = "jkailasam"
  }
}

*/