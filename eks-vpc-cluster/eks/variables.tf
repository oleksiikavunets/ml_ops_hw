variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "hw-5-6"
}

variable "vpc_state_bucket" {
  type = string
  default = "mlops-tf-state-goit"
}
variable "vpc_state_key"    {
  type = string
  default = "vpc/terraform.tfstate"
}
