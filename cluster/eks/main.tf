module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = "${var.project_name}-cluster"
  cluster_version = "1.30"

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  cluster_endpoint_public_access           = var.cluster_endpoint_public_access
  cluster_endpoint_private_access          = var.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  eks_managed_node_groups = {
    cpu_nodes = {
      desired_size   = var.cpu_nodes_desired_size
      max_size       = var.cpu_nodes_max_size
      min_size       = var.cpu_nodes_min_size
      instance_types = var.cpu_nodes_instance_types
    }

    gpu_nodes = {
      desired_size   = var.gpu_nodes_desired_size
      max_size       = var.gpu_nodes_max_size
      min_size       = var.gpu_nodes_min_size
      instance_types = var.gpu_nodes_instance_types
    }
  }
}
