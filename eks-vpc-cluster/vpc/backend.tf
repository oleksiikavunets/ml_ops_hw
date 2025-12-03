terraform {
  backend "s3" {
    bucket = var.tf_state_bucket
    key    = var.vpc_state_key
    region = var.aws_region
  }
}
