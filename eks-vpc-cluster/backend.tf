terraform {
  backend "s3" {
    bucket = "mlops-tf-state-goit"
    key    = "root/terraform.tfstate"
    region = "us-east-1"
  }
}
