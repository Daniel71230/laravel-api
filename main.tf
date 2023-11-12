terraform {
  required_version = "~> 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "ecrRepo" {
  source = "./modules/ecr"

  ecr_repo_name = local.ecr_repo_name
}

module "ecsCluster" {
  source = "./modules/ecs"

  laravel_app_cluster_name = local.laravel_app_cluster_name
  availability_zones    = local.availability_zones

  laravel_app_task_family         = local.laravel_app_task_family
  ecr_repo_url                 = module.ecrRepo.repository_url
  container_port               = local.container_port
  laravel_app_task_name        = local.laravel_app_task_name
  ecs_task_execution_role_name = local.ecs_task_execution_role_name
  app_load_balancer_name = local.app_load_balancer_name
  target_group_name              = local.target_group_name
  laravel_app_service_name          = local.laravel_app_service_name
  cloudwatch_group =   local.cloudwatch_group
}
