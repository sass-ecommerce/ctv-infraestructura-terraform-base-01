output "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "account_id" {
  description = "AWS Account ID — use this in backend.tf of each environment"
  value       = data.aws_caller_identity.current.account_id
}

output "state_lock_table_name" {
  description = "DynamoDB table name for Terraform state locking — use this in backend.tf of each environment"
  value       = aws_dynamodb_table.terraform_state_lock.name
}
