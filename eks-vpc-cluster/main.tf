locals {
  cluster_name = "${var.project_name}-cluster"
}

module "vpc" {
  source = "./vpc"

  project_name = var.project_name
  aws_region   = var.aws_region
}

module "eks" {
  source = "./eks"

  project_name = var.project_name
  aws_region   = var.aws_region

  vpc_state_bucket = "mlops-tf-state-goit"
  vpc_state_key    = "vpc/terraform.tfstate"
}
