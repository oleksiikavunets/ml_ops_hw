variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "tf_state_bucket" {
  type = string
}

variable "vpc_state_key" {
  type    = string
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "map_public_ip_on_launch" {
  type = bool
}

variable "enable_nat_gateway" {
  type = bool
}

variable "single_nat_gateway" {
  type = bool
}

variable "one_nat_gateway_per_az" {
  type = bool
}
