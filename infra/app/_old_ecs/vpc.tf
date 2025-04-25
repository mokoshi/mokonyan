# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.app_name}-${var.environment}"
  }
}

# パブリックサブネット（AZ-a）
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-${var.environment}-public-a"
  }
}

# パブリックサブネット（AZ-c）
resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-${var.environment}-public-c"
  }
}

# プライベートサブネット（AZ-a）
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.app_name}-${var.environment}-private-a"
  }
}

# プライベートサブネット（AZ-c）
resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.app_name}-${var.environment}-private-c"
  }
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-${var.environment}"
  }
}

# パブリックルートテーブル
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.app_name}-${var.environment}-public"
  }
}

# パブリックサブネットとルートテーブルの関連付け（AZ-a）
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# パブリックサブネットとルートテーブルの関連付け（AZ-c）
resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

# NAT ゲートウェイ用の EIP（AZ-a）
resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = {
    Name = "${var.app_name}-${var.environment}-nat-a"
  }
}

# NAT ゲートウェイ（AZ-a）
resource "aws_nat_gateway" "main_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "${var.app_name}-${var.environment}-a"
  }

  depends_on = [aws_internet_gateway.main]
}

# NAT ゲートウェイ用の EIP（AZ-c）
resource "aws_eip" "nat_c" {
  domain = "vpc"

  tags = {
    Name = "${var.app_name}-${var.environment}-nat-c"
  }
}

# NAT ゲートウェイ（AZ-c）
resource "aws_nat_gateway" "main_c" {
  allocation_id = aws_eip.nat_c.id
  subnet_id     = aws_subnet.public_c.id

  tags = {
    Name = "${var.app_name}-${var.environment}-c"
  }

  depends_on = [aws_internet_gateway.main]
}

# プライベートルートテーブル（AZ-a）
resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_a.id
  }

  tags = {
    Name = "${var.app_name}-${var.environment}-private-a"
  }
}

# プライベートルートテーブル（AZ-c）
resource "aws_route_table" "private_c" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_c.id
  }

  tags = {
    Name = "${var.app_name}-${var.environment}-private-c"
  }
}

# プライベートサブネットとルートテーブルの関連付け（AZ-a）
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

# プライベートサブネットとルートテーブルの関連付け（AZ-c）
resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private_c.id
}

