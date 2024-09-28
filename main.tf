terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  required_version = ">= 0.12"
}

provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source = "./networking"
}

module "auth" {
  source = "./auth"
}

module "lambda" {
  source = "./lambda"
  db_password = var.db_password
  jwt_secret = var.jwt_secret
}

module "api_gateway" {
  source = "./api_gateway"
  lambda_integration_uri = module.lambda.auth_function_invoke_arn
}  

module "database" {
  source = "./database"
  db_username = var.db_username
  db_password = var.db_password 
  db_sg_ids = module.networking.db_sg_ids
}

module "kubernetes" {
  source = "./kubernetes"
  app_image = var.app_image
}

module "monitoring" {
  source = "./monitoring"
}

module "secrets" {
  source = "./secrets"
  db_username = var.db_username
  db_password = var.db_password
}