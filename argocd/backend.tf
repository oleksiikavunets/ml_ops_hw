terraform {
  backend "s3" {
    bucket  = "mlops-tf-state-goit"
    key     = "argocd/terraform.tfstate"
    region  = "us-east-1"
    profile = "goit-terraform"
  }
}
