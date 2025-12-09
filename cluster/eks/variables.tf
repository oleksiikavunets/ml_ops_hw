variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "tf_state_bucket" {
  type = string
}

variable "tf_state_key" {
  type    = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "cluster_endpoint_public_access" {
  type = bool
}

variable "cluster_endpoint_private_access" {
  type = bool
}

variable "cluster_endpoint_public_access_cidrs" {
  type = list(string)
}

variable "enable_cluster_creator_admin_permissions" {
  type = bool
}

# CPU variables
variable "cpu_nodes_desired_size" {
  type = number
}

variable "cpu_nodes_max_size" {
  type = number
}

variable "cpu_nodes_min_size" {
  type = number
}

variable "cpu_nodes_instance_types" {
  type = list(string)
}

# GPU variables
variable "gpu_nodes_desired_size" {
  type = number
}

variable "gpu_nodes_max_size" {
  type = number
}

variable "gpu_nodes_min_size" {
  type = number
}

variable "gpu_nodes_instance_types" {
  type = list(string)
}
