terraform {
  backend "s3" {
    bucket = "mlops-tf-state-goit"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}
