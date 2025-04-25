#!/bin/bash

# Exit on error
set -e

# Get AWS account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION="ap-northeast-1"
ECR_REPOSITORY="mokonyan"
IMAGE_TAG="latest"

# Create and use buildx builder if it doesn't exist
echo "Setting up buildx..."
docker buildx create --use --name multiarch-builder || true

# Build Docker image with buildx
echo "Building Docker image..."
docker buildx build \
  --platform linux/amd64 \
  -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG} \
  --push \
  .

echo "Done!" 