provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  bucket_name     = "${var.project}-terraform-state-${var.environment}"
  lock_table_name = "${var.project}-terraform-state-lock-${var.environment}"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = local.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = local.lock_table_name
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

