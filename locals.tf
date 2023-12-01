locals {
  ecr_repo_name = "laravel-app-ecr-repo"

  laravel_app_cluster_name        = "laravel-web-app"
  availability_zones           = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  laravel_app_task_family         = "laravel-web-app"
  container_port               = 8080
  laravel_app_task_name           = "laravel-web-app"
  ecs_task_execution_role_name = "laravel-web-app-execution-role"
  app_load_balancer_name = "laravel-app-alb"
  target_group_name              = "laravel-alb-tg"

  laravel_app_service_name = "laravel-app-service"
  cloudwatch_group = "ecs_cloudwatch"
}
