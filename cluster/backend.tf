terraform {
  backend "s3" {
    bucket = "mlops-tf-state-goit"
    key    = "cluster/terraform.tfstate"
    region = "us-east-1"
  }
}
