
locals {
  cluster_name = "${var.project_name}-cluster"
}

module "vpc" {
  source = "./vpc"

  project_name = var.project_name
  aws_region   = var.aws_region

  tf_state_bucket = var.tf_state_bucket
  vpc_state_key   = var.tf_state_key

  vpc_cidr                = var.vpc_cidr
  availability_zones      = var.availability_zones
  public_subnets          = var.public_subnets
  private_subnets         = var.private_subnets
  map_public_ip_on_launch = var.map_public_ip_on_launch
  enable_nat_gateway      = var.enable_nat_gateway
  single_nat_gateway      = var.single_nat_gateway
  one_nat_gateway_per_az  = var.one_nat_gateway_per_az
}

module "eks" {
  source = "./eks"

  project_name = var.project_name
  aws_region   = var.aws_region

  tf_state_bucket = var.tf_state_bucket
  tf_state_key   = var.tf_state_key

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access           = var.cluster_endpoint_public_access
  cluster_endpoint_private_access          = var.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  cpu_nodes_desired_size   = var.cpu_nodes_desired_size
  cpu_nodes_max_size       = var.cpu_nodes_max_size
  cpu_nodes_min_size       = var.cpu_nodes_min_size
  cpu_nodes_instance_types = var.cpu_nodes_instance_types

  gpu_nodes_desired_size   = var.gpu_nodes_desired_size
  gpu_nodes_max_size       = var.gpu_nodes_max_size
  gpu_nodes_min_size       = var.gpu_nodes_min_size
  gpu_nodes_instance_types = var.gpu_nodes_instance_types
}
