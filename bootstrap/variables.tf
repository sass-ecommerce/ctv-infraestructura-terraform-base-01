variable "aws_region" {
  type        = string
  description = "AWS region where the state backend resources will be created"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev or prod)"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be one of: dev, prod"
  }
}

variable "project" {
  type        = string
  description = "Project name used for resource naming and tags"
  default     = "chapa-tu-venta"
}
