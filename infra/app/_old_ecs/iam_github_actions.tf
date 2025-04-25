# IAM user for GitHub Actions
resource "aws_iam_user" "github_actions" {
  name = "github-actions-mokonyan"
  path = "/github-actions/"

  tags = local.common_tags
}

# IAM access key for GitHub Actions user
resource "aws_iam_access_key" "github_actions" {
  user = aws_iam_user.github_actions.name
}

# IAM policy for GitHub Actions
resource "aws_iam_user_policy" "github_actions" {
  name = "github-actions-mokonyan-policy"
  user = aws_iam_user.github_actions.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = "arn:aws:ecr:${var.aws_region}:*:repository/${var.app_name}-${var.environment}"
      },
      {
        Effect = "Allow"
        Action = [
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ]
        Resource = [
          "arn:aws:ecs:${var.aws_region}:*:task-definition/${var.app_name}-${var.environment}:*",
          "arn:aws:ecs:${var.aws_region}:*:service/${var.app_name}-${var.environment}/${var.app_name}-${var.environment}"
        ]
      }
    ]
  })
}

# Output the access key and secret
output "github_actions_access_key_id" {
  value     = aws_iam_access_key.github_actions.id
  sensitive = true
}

output "github_actions_secret_access_key" {
  value     = aws_iam_access_key.github_actions.secret
  sensitive = true
}
