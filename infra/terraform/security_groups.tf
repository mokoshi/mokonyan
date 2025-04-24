# ECS Tasks Security Group
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.app_name}-${var.environment}-ecs-tasks"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.main.id

  # アウトバウンドルール
  egress {
    from_port   = 443 # HTTPS
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS outbound traffic"
  }

  egress {
    from_port   = 80 # HTTP
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP outbound traffic"
  }

  tags = local.common_tags
}

# Allow inbound traffic from ALB
resource "aws_security_group_rule" "ecs_tasks_ingress" {
  type                     = "ingress"
  from_port                = var.container_port
  to_port                  = var.container_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.ecs_tasks.id
  description              = "Allow inbound traffic from ALB"
}

# ALB Security Group
resource "aws_security_group" "alb" {
  name        = "${var.app_name}-${var.environment}-alb"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  # HTTPS インバウンドルール
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS inbound traffic"
  }

  # アウトバウンドルール
  egress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic to ECS tasks"
  }

  tags = local.common_tags
}
