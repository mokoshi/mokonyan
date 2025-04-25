# Caller identity を取ってリソース ARN に埋め込む
data "aws_caller_identity" "current" {}

# IAM user for GitHub Actions
resource "aws_iam_user" "github_actions" {
  name = "github-actions-${var.app_name}-${var.environment}"
  path = "/github-actions/"

  tags = local.common_tags
}

# IAM access key for GitHub Actions user
resource "aws_iam_access_key" "github_actions" {
  user = aws_iam_user.github_actions.name
}

# IAM inline policy for GitHub Actions
resource "aws_iam_user_policy" "github_actions" {
  name = "github-actions-${var.app_name}-${var.environment}-policy"
  user = aws_iam_user.github_actions.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ECR の認証トークン取得
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      # ECR リポジトリへのプッシュ／取得権限
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
        Resource = "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/${var.app_name}"
      },
      # Lightsail コンテナサービスのデプロイ取得＆更新
      # > Resource レベル不可の読み取りアクションは "*" を使う
      {
        Effect   = "Allow"
        Action   = ["lightsail:GetContainerServices"]
        Resource = "*"
      },
      # > デプロイ作成はリソースレベル指定可能
      {
        Effect   = "Allow"
        Action   = ["lightsail:CreateContainerServiceDeployment"]
        Resource = aws_lightsail_container_service.app.arn
      }
    ]
  })
}

# Outputs (機密情報)
output "github_actions_access_key_id" {
  value     = aws_iam_access_key.github_actions.id
  sensitive = true
}

output "github_actions_secret_access_key" {
  value     = aws_iam_access_key.github_actions.secret
  sensitive = true
}
