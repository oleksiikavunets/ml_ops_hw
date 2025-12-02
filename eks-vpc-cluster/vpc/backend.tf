terraform {
  backend "s3" {
    bucket = "mlops-tf-state-goit"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
