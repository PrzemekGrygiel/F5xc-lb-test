variable "key_name" {
  default = "przemek-oregon"
}
variable "key_path" {
  default = "/Users/grygiel/Documents/keys/aws/przemek-oregon.pem"
}

variable vm_instance_type {
  default = "t2.small"
}

variable projectPrefix {
  default = "pg-auto-lb4"
}

# AWS 
variable "aws_region" {
  default = "us-west-2"
}

variable "volterra_key_name" {
  default = "przemek-aws"  
}

variable "namespace" {
    default = "pg"
}

variable domain {
    default = "edge.mwlabs.net"
}

variable "instances_number" {
    default = 4
}