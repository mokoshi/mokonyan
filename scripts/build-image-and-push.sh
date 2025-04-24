#!/bin/bash

# Exit on error
set -e

# Get AWS account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION="ap-northeast-1"
ECR_REPOSITORY="mokonyan-dev"
IMAGE_TAG="latest"

# Build Docker image
echo "Building Docker image..."
docker build -t mokoshi/${ECR_REPOSITORY}:${IMAGE_TAG} .

# Log in to ECR
echo "Logging in to ECR..."
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Tag image for ECR
echo "Tagging image for ECR..."
docker tag ${ECR_REPOSITORY}:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG}

# Push image to ECR
echo "Pushing image to ECR..."
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG}

echo "Done!" 