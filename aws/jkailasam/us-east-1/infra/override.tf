provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/jkailasam/.aws/credentials"
  profile                 = "jkailasam"
}

variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDc+uM6tLX0En+34xW9SJzGMfyCtS5ymLvYRjioLxQ2yJr4+BKXMRgUJWxpA3klX+cLHwE2dojpsVae71pljGzVeNE4s88LSmcuUnPUgvf3rNWsw0+dmILdeF7JieRphSieI/xkwTXeboMPTXjI8dm8rUrk+SN57uYSg8wYyloWQdg96ZgwGFTFJQUbLhpXSzCcQpMxVjDBl9E1lGkR6T3Ad7w4tATBU0cI0PaU+XhPHmzw0YdDZdEo8XFkIR+g2aJOlBFSdLFPehTdZiByp643rW43LUP81O6A6HxNJixDiQkVaNv2WJjGFBY9PjvGOHFQthCh1j/Hf3BYd2/DLvbh Jeeva's Key"
}

variable "nat_ip" {
  default = "10.10.16.10"
}