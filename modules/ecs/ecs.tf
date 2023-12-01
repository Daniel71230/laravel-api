resource "aws_ecs_cluster" "laravel_app_cluster" {    # ECS klastera izveide
  name = var.laravel_app_cluster_name
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



resource "aws_default_vpc" "default_vpc" {}

resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = var.availability_zones[0]
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = var.availability_zones[1]
}

/*resource "aws_alb" "app_load_balancer" {
  name               = var.app_load_balancer_name
  load_balancer_type = "application"
  subnets = [
    "${aws_default_subnet.default_subnet_a.id}",
    "${aws_default_subnet.default_subnet_b.id}"
  ]
  security_groups = ["${aws_security_group.load_balancer_security_group.id}", "sg-0ca883d581e8c6e8b"]
}

resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}*/

resource "aws_lb_target_group" "target_group" {
  name        = var.target_group_name
  port        = "80"
  protocol    = "HTTP"
  target_type = "ip"
  ip_address_type = "ipv4"
  protocol_version = "http1"
  vpc_id      = aws_default_vpc.default_vpc.id
   health_check {
        healthy_threshold   = "2"
        unhealthy_threshold = 3
        interval            = "15"
        protocol            = "http"
        matcher             = "150"
        timeout             = "7"
    }   
}

/*resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.app_load_balancer.id
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}*/

/*resource "aws_ecs_service" "laravel_app_service" {
  name            = var.laravel_app_service_name
  cluster         = aws_ecs_cluster.laravel_app_cluster.id
  task_definition = aws_ecs_task_definition.laravel_app_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = aws_ecs_task_definition.laravel_app_task.family
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}", "${aws_default_subnet.default_subnet_c.id}"]
    assign_public_ip = true
    security_groups  = ["${aws_security_group.service_security_group.id}", "sg-0ca883d581e8c6e8b", "sg-0c60fad80a982e530", "sg-0ca18d55621ed8fdc"]
  }
}*/

/*resource "aws_security_group" "service_security_group" {
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["sg-0ca883d581e8c6e8b", "sg-0c60fad80a982e530", "sg-0ca18d55621ed8fdc"]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}*/

