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
/*
module "network" {
  source = "./network"
}

module "task-definition" {
  source = "./task-definitions"
}

module "clusters" {
  source = "./clusters"
}
*/

module "services" {
    source = "./clusters/services"
}
