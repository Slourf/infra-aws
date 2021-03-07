terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

module "toh" {
  source = "./toh"

  app_name = "toh"

  backend_port  = var.backend_port
  frontend_port = var.frontend_port
  github        = var.github
  db_user       = var.db_user
  db_password   = var.db_password
}