resource "aws_lightsail_container_service" "app" {
  name        = "${var.app_name}-${var.environment}"
  power       = "nano"
  scale       = 1
  is_disabled = false

  private_registry_access {
    ecr_image_puller_role {
      is_active = true
    }
  }
}

resource "aws_lightsail_container_service_deployment_version" "app" {
  container {
    container_name = var.app_name
    image          = "${aws_ecr_repository.app.repository_url}:latest"
    environment = {
      NODE_ENV                  = "production"
      OPENAI_API_KEY            = var.openai_api_key
      SLACK_SIGNING_SECRET      = var.slack_signing_secret
      SLACK_BOT_TOKEN           = var.slack_bot_token
      TURSO_DATABASE_URL        = var.turso_database_url
      TURSO_DATABASE_AUTH_TOKEN = var.turso_database_auth_token
    }
    ports = {
      (var.container_port) = "HTTP"
    }
  }

  public_endpoint {
    container_name = var.app_name
    container_port = var.container_port

    health_check {
      path                = "/health"
      success_codes       = "200"
      interval_seconds    = 5
      timeout_seconds     = 2
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }
  }

  service_name = aws_lightsail_container_service.app.name
}
