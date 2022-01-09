terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIAQZ4EJHNIBNFZ3DVR"
  secret_key = "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"
}
resource "aws_instance" "myec2" {
    ami="ami-047a51fa27710816e"
    instance_type="t2.micro"
}
