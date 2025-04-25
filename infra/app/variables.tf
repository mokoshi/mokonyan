variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "environment" {
  description = "Environment (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "mokonyan"
}

variable "domain_name" {
  description = "Base domain name for the application"
  type        = string
  default     = "mokoshi.red"
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 3000
}

# OpenAI
variable "openai_api_key" {
  description = "OpenAI API key"
  type        = string
  sensitive   = true
}

# Slack
variable "slack_signing_secret" {
  description = "Slack signing secret"
  type        = string
  sensitive   = true
}

variable "slack_bot_token" {
  description = "Slack bot token"
  type        = string
  sensitive   = true
}

# Turso
variable "turso_database_url" {
  description = "Turso database URL"
  type        = string
  sensitive   = true
}

variable "turso_database_auth_token" {
  description = "Turso database authentication token"
  type        = string
  sensitive   = true
}

variable "google_custom_search_api_key" {
  description = "Google Custom Search API key"
  type        = string
  sensitive   = true
}

variable "google_custom_search_engine_id" {
  description = "Google Custom Search engine ID"
  type        = string
  sensitive   = true
}
