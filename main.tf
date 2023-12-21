terraform {
  required_version = "~> 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "ecr" {
  source = "./modules/ecr"

  ecr_repo_name = local.ecr_repo_name
}

module "ecs" {
  source = "./modules/ecs"

  laravel_app_cluster_name = local.laravel_app_cluster_name
  laravel_app_task_family         = local.laravel_app_task_family
  ecr_repo_url                 = module.ecr.repository_url
  container_port               = local.container_port
  laravel_app_task_name        = local.laravel_app_task_name
  ecs_task_execution_role_name = local.ecs_task_execution_role_name
  cloudwatch_group =   local.cloudwatch_group
  /*ecs_service_name = local.ecs_service_name
  vpc_id = "vpc-00978fc9d2c12f5e5"
  availability_zones = local.availability_zones*/
}
