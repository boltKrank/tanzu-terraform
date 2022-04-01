terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"

}

provider "aws" {
  profile = "default"
  region  = "ap-southeast-2"
}

# Create 3 Ubuntu 20.04 instances (ami-01f87c43e618bf8f0)

# resource "aws_instance" "app_server" {
#   ami           = "ami-01f87c43e618bf8f0"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "ExampleAppServerInstance"
#   }
# }

