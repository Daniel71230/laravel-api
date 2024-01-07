resource "aws_ecs_cluster" "laravel_app_cluster" {    # ECS klastera izveide
  name = var.laravel_app_cluster_name
  setting {             # Ļauj CloudWatch servisam automatiski saņemt metrikas par CPU, atmiņu un tīklu,  
    name  = "containerInsights" #  kā arī parādīt diagnostikas informāciju par kļūmēm
    value = "enabled"
  }


}

resource "aws_ecs_task_definition" "laravel_app_task" {    # ECS uzdevuma izveide
  family                   = var.laravel_app_task_family   # ECR attēls, servera ports un Cloudwatch logs tiek definēti JSON masīvā
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.laravel_app_task_name}",
      "image": "${var.ecr_repo_url}",                
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${var.container_port},
          "hostPort": ${var.container_port}
        }
      ],
      "secrets": [
        {
          "name": "DB_USERNAME",
          "valueFrom": "arn:aws:secretsmanager:eu-west-1:242611965122:secret:rds!db-53196283-0851-4fd5-8ef8-dcac4ef7b04d-tBzML2:username::"
        },
        {
          "name": "DB_PASSWORD",
          "valueFrom": "arn:aws:secretsmanager:eu-west-1:242611965122:secret:rds!db-53196283-0851-4fd5-8ef8-dcac4ef7b04d-tBzML2:password::"
        }
        ],
      "logConfiguration": {
          "logDriver": "awslogs",                            
          "options": {    
            "awslogs-group": "${var.cloudwatch_group}",
            "awslogs-region": "eu-west-1",
            "awslogs-stream-prefix": "ecs"
          }
        }
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]                           # ECS dzinēja tips. Fargate ir bezservera dzinējs, kas ir vislabāk piemērots nelielai testa vietnei.
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_iam_role" "ecs_task_execution_role" {                        # Uzdevuma palaišanas piekļūves definēšana
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {    # Vairākas politikas tiek pievienotas ciklā
   for_each = toset([
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",    # ECS uzdevuma palaišanas politika
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"                           # Secres manager datu piekļuves politika
  ])

  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = each.value
}

resource "aws_cloudwatch_log_group" "cloudwatch_group" {                    # CLoudwatch logu grupas izveide
  name = var.cloudwatch_group
}
