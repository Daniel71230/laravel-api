locals {
  ecr_repo_name = "laravel-app-ecr-repo"

  laravel_app_cluster_name        = "laravel-web-app"
  laravel_app_task_family         = "laravel-web-app"
  laravel_app_task_name           = "laravel-web-app"
  ecs_task_execution_role_name = "laravel-web-app-execution-role"
  container_port               = 8081
  cloudwatch_group = "ecs_cloudwatch"
}
