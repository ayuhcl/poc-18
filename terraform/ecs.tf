resource "aws_ecs_cluster" "main" {
  name = "poc18-ecs-cluster"
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/poc18"
  retention_in_days = 7
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole-poc18"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "poc18-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "website"
      image = "${aws_ecr_repository.website_repo.repository_url}:latest"

      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]

      environment = [
  {
    name  = "DB_HOST"
    value = aws_rds_cluster.aurora.endpoint
  },
  {
    name  = "DB_USER"
    value = "adminuser"
  },
  {
    name  = "DB_PASSWORD"
    value = "Password123!"
  },
  {
    name  = "DB_NAME"
    value = "postgres"
  }
]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "poc18-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn

  desired_count = 2

  launch_type = "FARGATE"

  network_configuration {

    subnets = [
      aws_subnet.private_1.id,
      aws_subnet.private_2.id
    ]

    security_groups = [
      aws_security_group.ecs_sg.id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "website"
    container_port   = 3000
  }

  depends_on = [
    aws_lb_listener.main
  ]
}
