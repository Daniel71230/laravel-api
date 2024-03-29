variable "laravel_app_cluster_name" {
  description = "ECS Cluster Name"
  type        = string
}

variable "laravel_app_task_family" {
  description = "ECS Task Family"
  type        = string
}

variable "ecr_repo_url" {
  description = "ECR Repo URL"
  type        = string
}

variable "container_port" {
  description = "Container Port"
  type        = number
}

variable "laravel_app_task_name" {
  description = "ECS Task Name"
  type        = string
}

variable "ecs_task_execution_role_name" {
  description = "ECS Task Execution Role Name"
  type        = string
}

variable "cloudwatch_group" {
  description = "CloudWatch group name."
  type = string
  default = "supreme-task-group"
}




