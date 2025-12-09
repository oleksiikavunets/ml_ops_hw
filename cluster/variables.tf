variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "hw-8-9"
}

variable "aws_profile" {
  type    = string
  default = "goit-terraform"
}

# Terraform state
variable "tf_state_bucket" {
  type    = string
  default = "mlops-tf-state-goit"
}

variable "tf_state_key" {
  type    = string
  default = "cluster/terraform.tfstate"
}

# VPC variables
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "map_public_ip_on_launch" {
  type    = bool
  default = true
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

variable "one_nat_gateway_per_az" {
  type    = bool
  default = true
}

# EKS variables
variable "cluster_endpoint_public_access" {
  type    = bool
  default = true
}

variable "cluster_endpoint_private_access" {
  type    = bool
  default = true
}

variable "cluster_endpoint_public_access_cidrs" {
  type    = list(string)
  default = ["84.40.153.18/32"]
}

variable "enable_cluster_creator_admin_permissions" {
  type    = bool
  default = true
}

variable "cpu_nodes_desired_size" {
  type    = number
  default = 1
}

variable "cpu_nodes_max_size" {
  type    = number
  default = 1
}

variable "cpu_nodes_min_size" {
  type    = number
  default = 1
}

variable "cpu_nodes_instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "gpu_nodes_desired_size" {
  type    = number
  default = 1
}

variable "gpu_nodes_max_size" {
  type    = number
  default = 1
}

variable "gpu_nodes_min_size" {
  type    = number
  default = 1
}

variable "gpu_nodes_instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

