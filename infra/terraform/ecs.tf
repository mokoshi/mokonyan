# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = local.common_tags
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app_name}-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = templatefile("${path.module}/container_definitions.json", {
    app_name                      = var.app_name
    repository_url                = aws_ecr_repository.main.repository_url
    container_port                = var.container_port
    environment                   = var.environment
    turso_database_url            = var.turso_database_url
    slack_signing_secret_arn      = aws_ssm_parameter.slack_signing_secret.arn
    slack_bot_token_arn           = aws_ssm_parameter.slack_bot_token.arn
    openai_api_key_arn            = aws_ssm_parameter.openai_api_key.arn
    turso_database_auth_token_arn = aws_ssm_parameter.turso_database_auth_token.arn
    log_group_name                = aws_cloudwatch_log_group.main.name
    aws_region                    = var.aws_region
  })

  tags = local.common_tags
}

# ECS Service
resource "aws_ecs_service" "main" {
  name            = "${var.app_name}-${var.environment}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_a.id, aws_subnet.private_c.id]
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = var.app_name
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.http]

  tags = local.common_tags
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/${var.app_name}-${var.environment}"
  retention_in_days = 30

  tags = local.common_tags
}
