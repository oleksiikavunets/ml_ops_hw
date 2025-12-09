variable "aws_profile" {
  type    = string
  default = "goit-terraform"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "eks_state_bucket" {
  type    = string
  default = "mlops-tf-state-goit"
}

variable "eks_state_key" {
  type    = string
  default = "cluster/terraform.tfstate"
}

variable "argocd_namespace" {
  description = "Namespace для Argo CD"
  type        = string
  default     = "infra-tools"
}

variable "argocd_chart_version" {
  description = "Версія Helm-чарту Argo CD"
  type        = string
  default     = "v7.7.5"
}
