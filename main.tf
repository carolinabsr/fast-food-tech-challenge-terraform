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

module "api_gateway" {
  source = "./api_gateway"
}

module "auth" {
  source = "./auth"
}

module "database" {
  source = "./database"
  db_username = var.db_username
  db_password = var.db_password
}

module "kubernetes" {
  source = "./kubernetes"
  app_image = var.app_image
}

module "lambda" {
  source = "./lambda"
  db_password = var.db_password
  jwt_secret = var.jwt_secret
}

module "monitoring" {
  source = "./monitoring"
}

module "networking" {
  source = "./networking"
}

module "secrets" {
  source = "./secrets"
  db_username = var.db_username
  db_password = var.db_password

}

output "api_gateway_rest_api_id" {
  value = module.api_gateway.rest_api_id
}

# output "auth_user_pool_id" {
#   value = module.auth.user_pool_id
# }

output "database_instance_address" {
  value = module.database.instance_address
}

output "kubernetes_cluster_endpoint" {
  value = module.kubernetes.cluster_endpoint
}

output "lambda_function_arn" {
  value = module.lambda.function_arn
}

output "monitoring_log_group_name" {
  value = module.monitoring.log_group_name
}

# output "networking_vpc_id" {
#   value = module.networking.vpc_id
# }

# output "secrets_db_credentials_arn" {
#   value = module.secrets.db_credentials_arn
# }
