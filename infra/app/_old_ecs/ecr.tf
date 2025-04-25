# ECR Repository
resource "aws_ecr_repository" "main" {
  name         = "${var.app_name}-${var.environment}"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.common_tags
}
