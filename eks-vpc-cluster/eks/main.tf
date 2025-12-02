data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.vpc_state_bucket
    key    = var.vpc_state_key
    region = var.aws_region
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = "${var.project_name}-cluster"
  cluster_version = "1.30"

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets

  cluster_endpoint_public_access           = true
  cluster_endpoint_private_access          = true
  cluster_endpoint_public_access_cidrs     = ["84.40.153.31/32"]
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    cpu_nodes = {
      desired_size   = 1
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.micro"]
    }

    gpu_nodes = {
      desired_size   = 1
      max_size       = 2
      min_size       = 1
      instance_types = ["t3.micro"]
    }
  }
}
