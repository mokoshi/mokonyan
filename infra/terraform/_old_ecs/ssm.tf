# OpenAI
resource "aws_ssm_parameter" "openai_api_key" {
  name        = "/${var.app_name}/${var.environment}/openai/api-key"
  description = "OpenAI API key for ${var.app_name} in ${var.environment}"
  type        = "SecureString"
  value       = var.openai_api_key

  tags = local.common_tags
}

# Slack
resource "aws_ssm_parameter" "slack_signing_secret" {
  name        = "/${var.app_name}/${var.environment}/slack/signing-secret"
  description = "Slack signing secret for ${var.app_name} in ${var.environment}"
  type        = "SecureString"
  value       = var.slack_signing_secret

  tags = local.common_tags
}

resource "aws_ssm_parameter" "slack_bot_token" {
  name        = "/${var.app_name}/${var.environment}/slack/bot-token"
  description = "Slack bot token for ${var.app_name} in ${var.environment}"
  type        = "SecureString"
  value       = var.slack_bot_token

  tags = local.common_tags
}

# Turso
resource "aws_ssm_parameter" "turso_database_auth_token" {
  name        = "/${var.app_name}/${var.environment}/turso/auth-token"
  description = "Turso database authentication token for ${var.app_name} in ${var.environment}"
  type        = "SecureString"
  value       = var.turso_database_auth_token

  tags = local.common_tags
}
