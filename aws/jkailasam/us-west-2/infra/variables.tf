variable "aws_access_key" {
  default = ""
  description = "the user aws access key"
}

variable "aws_secret_key" {
  default = ""
  description = "the user aws secret key"
}

variable "profile" {
  default = "jkailasam"
  description = "AWS profile to use authenticate"
}

variable "credential_file" {
  default = "/Users/jkailasam/.aws/credentials"
  description = "AWS Credentials file"
}

variable "region" {
  default = "us-west-2"
}

variable "AMI-Ubuntu" {
  type = "map"
  default = {
    us-east-1 = "ami-43a15f3e"
    us-west-2 = "ami-4e79ed36"
    us-west-1 = "ami-925144f2"
    eu-west-1 = "ami-f90a4880"
  }
  description = "Added only 4 regions to show the map feature"
}

variable "cidr" {
  type= "map"
  default = {
    vpc0 = "10.10.0.0/20"
    vpc0-public-2a = "10.10.0.0/24"
    vpc0-public-2b = "10.10.1.0/24"
    vpc0-public-2c = "10.10.2.0/24"
    vpc0-private-2a = "10.10.8.0/24"
    vpc0-private-2b = "10.10.9.0/24"
    vpc0-private-2c = "10.10.10.0/24"

  }
}

variable "nat_ip" {
  default = "10.10.0.10"
}

variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDc+uM6tLX0En+34xW9SJzGMfyCtS5ymLvYRjioLxQ2yJr4+BKXMRgUJWxpA3klX+cLHwE2dojpsVae71pljGzVeNE4s88LSmcuUnPUgvf3rNWsw0+dmILdeF7JieRphSieI/xkwTXeboMPTXjI8dm8rUrk+SN57uYSg8wYyloWQdg96ZgwGFTFJQUbLhpXSzCcQpMxVjDBl9E1lGkR6T3Ad7w4tATBU0cI0PaU+XhPHmzw0YdDZdEo8XFkIR+g2aJOlBFSdLFPehTdZiByp643rW43LUP81O6A6HxNJixDiQkVaNv2WJjGFBY9PjvGOHFQthCh1j/Hf3BYd2/DLvbh Jeeva's Key"
  description = "Jeeva's Public Key"
}