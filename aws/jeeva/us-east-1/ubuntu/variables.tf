

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