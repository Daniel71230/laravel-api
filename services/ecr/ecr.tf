resource "aws_ecr_repository" "demo_app_ecr_repo" {
  name = var.repo_name
}